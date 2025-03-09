import Debug "mo:base/Debug";
import Array "mo:base/Array";
import Nat "mo:base/Nat";
import Timer "mo:base/Timer";
import Random "mo:base/Random";
import Iter "mo:base/Iter";
import Bool "mo:base/Bool";
import GoLNN "canister:GoLNN";


/*
 * This is the container that initializes, stores  and triggers updates of the GoL boardstate.
 */ 
actor MainSystem {
  // Variable for GoL state
  stable var grid: [[Bool]] = [];
  // Is GoL grid initialized
  stable var isInit: Bool = false;

  // Is Timer currently running
  var timerRunning: Bool = false;

  // Current time set up for timer
  var timerTime: Nat = 0;
  // Counter of how many times timer will run again, -1 for unlimited
  var timerCounter: Int = 0;
  // Current timer Id
  var timerId : Timer.TimerId = 0;

  // Init grid with random values
  public func initSelfRandom(height : Nat, width : Nat) {
    // Checking if board state is initialized
    if (not timerRunning) {

      Debug.print(debug_show ("Board initialization started"));
      // Setting it of so timers cannot be run
      isInit := false;

      // Setting up the gird
      var mutableGrid : [var [var Bool]] = Array.init<[var Bool]>(height, Array.init<Bool>(width, false));
      for (i in Iter.range(0, height - 1)) {
        mutableGrid[i] := Array.init<Bool>(width, false);
      };

      // Preparing random function
      var seed : Blob = await Random.blob();
      var seedRandom = Random.Finite(seed);
      var randomUseCounter : Nat = 0;

      for (i in Iter.range(0, height - 1)) {
          for (j in Iter.range(0, width - 1)) {      

            // Setting random value to cell
            mutableGrid[i][j] := switch (seedRandom.coin()) {
              case null false;
              case (?Bool) Bool;
            };

            // Updating random if expired
            randomUseCounter += 1;
            if (randomUseCounter > 255) {
              seed := await Random.blob();
              seedRandom := Random.Finite(seed);
            };

          };
      };

      // Freezing ans grid
      var ans : [var [Bool]] = Array.init<[Bool]>(height, []);
      for(i in Iter.range(0, height - 1)) {
          ans[i] := Array.freeze(mutableGrid[i]);
      }; 

      grid := Array.freeze(ans);
        
      isInit := true;

      Debug.print(debug_show ("Board inititalization finished", grid));
    } else {
      Debug.print(debug_show ("Timer is running cannot reinitialize new board", grid));
    }
  };

  // Init grid with specific values
  public func setGrid(newGrid : [[Bool]]) {
    grid := newGrid;
    isInit := true;
  };

  // Run one cycle
  private func runCycle() : async () {
    Debug.print(debug_show ("Cycle start"));
    grid := await GoLNN.applyNN(grid);

    // Checking if we need a new timer and running it
    if (timerCounter != 0) {
      timerId := Timer.setTimer<system>(#seconds timerTime, runCycle);
      if (timerCounter > 0) {
        timerCounter -= 1;
      };
    } else {
      timerRunning := false;
    };

    Debug.print(debug_show ("New grid state: \n", grid));
  };

  // Preparing to run X cycles negative value for cycles is inf
  public func runXCycles(cycles : Int, cycleTime : Nat) {
    // If there is already another timer deleting it
    Timer.cancelTimer(timerId);
    
    if (cycles == 0) {
        return;
    };
    
    if isInit {
      if (cycles > 0) {
        timerCounter := cycles - 1;
      } else {
        timerCounter := cycles;
      };
      timerRunning := true;
      timerTime := cycleTime;
      
      await runCycle();
    } else {
      Debug.print(debug_show ("Cannot run cycles, grid not initialized;"));
    };
  };

  public func cancelTimer(): () {
    Timer.cancelTimer(timerId);
  };

  public query func getState(): async [[Bool]] {
    grid
  };

};
