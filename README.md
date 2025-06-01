# Demo of the Future: Autonomous Web3 AI Agent Showcase

This is a demo for the IEEE International Conference on Blockchain and Cryptocurrency 2025 (ICBC 2025).

The demo showcases a minimalistic yet viable example of a Web3 AI agent through a smart contract using the Internet Computer (ICP) blockchain. The smart contract is designed to initiate a transaction once per given period of time, maintaining a chain of actions. This continuous transaction generation simulates autonomous behavior, with each transaction acting as a catalyst for the next. The architecture emphasizes minimalism by ensuring the blockchain contract remains efficient and cost-effective.

Conway's Game of Life serves as the framework within the smart contract, illustrating the agent's decision-making process. Each transaction maintains a binary image representing the game's state, which evolves with each iteration through a single iteration of a convolutional neural network. The CNN is optimized for blockchain execution, balancing complexity with the need for minimal computational resources.

The demo successfully showcases the autonomous behavior of the smart contract, with each transaction triggering the next iteration of the Game of Life. Insights gained include the potential for optimization and expansion of the neural network for more complex decision-making. The demonstration provides a foundational example for future development and experimentation in Web3 AI agents.

The demo is written in Motoko, HTML, and JavaScript languages.

## Video demonstration of the demo. 

[![Video demostration of demo workings.](http://img.youtube.com/vi/uz-tuK1Pn_A/0.jpg)](http://www.youtube.com/watch?v=uz-tuK1Pn_A)

## Running the demo.
### Prerequisites

- [x] Install the [IC SDK](https://internetcomputer.org/docs/current/developer-docs/setup/install/index.mdx).
- [x] Clone the example dapp project: `git clone https://github.com/Englekh/ICP_GoL`

### Step 1: Set Up the Project Environment

Navigate to the project folder and start a local instance of the Internet Computer with these commands:

```bash
cd examples/motoko/life
dfx start --background
```

### Step 3: Open the Frontend

Open the frontend in your browser by clicking the link returned in the output of the previous command.

#### Interface Controls

- **Initialize** – Generates the Game of Life grid on the backend. Cannot be executed while a simulation is running.  
- **Toggle Cell** – Flips the state of a single cell at the specified coordinates.  
- **Run** – Executes the Game of Life simulation for a specified number of iterations with a set delay between runs. Can run indefinitely if set to "-1" iterations.  
- **Stop Simulation** – Terminates any remaining simulation cycles.  
- **Update View** – Refreshes the field display in the frontend.  

## Authors:
**Nikolay Larionov**: MIPT Blockchain Department, Moscow, Russia <br>
**Grigorii Melnikov**: Gearbox Foundation, Budva, Montenegro, grmuller1996@gmail.com <br>
**Yash Madhwal**:Skolkovo Institute of Science and Technology, Moscow, Russia
**Yury Yanovich**:Skolkovo Institute of Science and Technology, Moscow, Russia
