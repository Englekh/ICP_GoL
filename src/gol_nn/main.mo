import Nat "mo:base/Nat";
import Array "mo:base/Array";
import Iter "mo:base/Iter";
//import Debug "mo:base/Debug";

actor gol_nn {

    let Center : [Nat] = [1, 1];

    let Weights : [[Nat]] = [[1, 1, 1], [1, 0, 1], [1, 1, 1]];


    public query func calcCell(grid : [[Bool]], Pos: [Nat]) : async Bool {

        // Initiating values
        var result: Nat = 0;
        let gridHeight = Array.size(grid);
        let gridWidth = Array.size(grid[0]);


        // Caluclating value
        for (i in Iter.range(0, Array.size(Weights) - 1)) {
            for (j in Iter.range(0, Array.size(Weights[0]) - 1)) {
                let posX : Nat = (gridHeight + Pos[0] + i - Center[0]) % gridHeight;
                let posY : Nat = (gridWidth + Pos[1] + j - Center[1]) % gridWidth;
                result += Weights[i][j] * (do {if (grid[posX][posY]) 1 else 0});
            };
        };

        return result == 3 or (result == 2 and not (grid[Pos[0]][Pos[1]]));
    };


    public func applyNN(grid : [[Bool]]) : async [[Bool]] {

        let height = Array.size(grid);
        let width = Array.size(grid[0]);

        // Initiating ans grid
        var mutableGrid : [var [var Bool]] = Array.init<[var Bool]>(height, Array.init<Bool>(width, false));
        for (i in Iter.range(0, height - 1)) {
            mutableGrid[i] := Array.init<Bool>(width, false);
        };
        // Calculating result
        for (i in Iter.range(0, Array.size(grid) - 1)) {
            for (j in Iter.range(0, Array.size(grid[0]) - 1)) {
                //Debug.print(debug_show ("Waiting", i, j));
                mutableGrid[i][j] := await calcCell(grid, [i, j]);  
            };
        };

        // Freezing ans grid
        var ans : [var [Bool]] = Array.init<[Bool]>(Array.size(grid), []);
        for(i in Iter.range(0, height - 1)) {
            ans[i] := Array.freeze(mutableGrid[i]);
        }; 

        return Array.freeze(ans)
    };

  
};