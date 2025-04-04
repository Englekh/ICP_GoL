import { html, render } from 'lit-html';
import { gol_backend } from 'declarations/gol_backend';


class App {
  field = '';

  constructor() {
    this.#init();
  }

  #init = async () => {
    
    this.field = gol_backend.getStateText();
    this.#render();
  }

  #fieldInit = async (e) => {
    e.preventDefault();
    const xSize = document.getElementById('FieldX').value.toNumber();
    const ySize = document.getElementById('FieldY').value.toNumber();
    await gol_backend.initSelfRandom(xSize, ySize);
    this.field = gol_backend.getStateText();
    this.#render();
  };

  #runCycles = async (e) => {
    e.preventDefault();
    const time = document.getElementById('ItersTime').value.toNumber();
    const cycles = document.getElementById('ItersNum').value.toNumber();
    await gol_backend.runXCycles(cycles, time);
    this.field = await gol_backend.getStateText();
    this.#render();
  };

  #change = async (e) => {
    e.preventDefault();
    const xSize = document.getElementById('ChangeX').value.toNumber();
    const ySize = document.getElementById('ChangeY').value.toNumber();
    await gol_backend.changeCell(xSize, ySize);
    this.field = await gol_backend.getStateText();
    this.#init();
  }

  #update = async (e) => {
    e.preventDefault();
    this.field = await gol_backend.getStateText();
    this.#init();
  }

  #stop = async (e) => {
    e.preventDefault();
    await gol_backend.cancelTimer();
    this.field = await gol_backend.getStateText();
    this.#render();
  }

  #render() {
    let body = html`
      <main>
      <label>Game of life bot</label>
      <br />
      <br />
      <init>
        <label> Init Size: </label>
        <input id="FieldX" alt="FieldX" type="number" placeholder="8"/>
        <input id="FieldY" alt="FieldY" type="number" placeholder="8"/>
        <button type="Init-btn"> Initialize field! </button>
      </init>
      <br />
   		<iter>
        <label> Iterations time interval:</label>
        <input id="ItersTime" alt="ItersTime" type="number" placeholder="8"/>
        <label> Iterations number (-1 = inf):</label>
        <input id="ItersNum" alt="ItersNum" type="number" placeholder="8"/>
        <button type="iterate-btn">Run</button>
      </iter>
   		<br />
   		<br />
   		<button id="stop-btn">Stop</button>
   		<br />
      <iter>
        <input id="ChangeX" alt="ChangeX" type="number" placeholder="8"/>
        <input id="ChangeY" alt="ChangeY" type="number" placeholder="8"/>
        <button type="change-btn">Change</button>
      </iter>
      <button id="Update-btn">Update</button>
   		<br />
      <section id="counter">Current field: ${this.counter}</section>
      </main>
    `;
    render(body, document.getElementById('root'));
    document.getElementById('Init-btn').addEventListener('click', this.#fieldInit);
    document.getElementById('iterate-btn').addEventListener('click', this.#runCycles);
    document.getElementById('stop-btn').addEventListener('click', this.#stop);
    document.getElementById('Update-btn').addEventListener('click', this.#update);
    document.getElementById('change-btn').addEventListener('click', this.#change);
  }
}

export default App;
