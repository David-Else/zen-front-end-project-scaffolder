// -----------------
// Node assert
// -----------------
const assert = require('assert').strict;
global.assert = assert;

// -----------------
// JSDom
// -----------------
const jsdom = require('jsdom');
const { JSDOM } = jsdom;
const { document } = new JSDOM(`
<!DOCTYPE html>
<html>
  <body>
  <div id="listOfPenguins" class="list-of-penguins"></div>

  <h1>Normalize Audio App</h1>

  <div id="app" class="box">
    <h2>Drag and drop audio files here</h2>
    <h4>Files ready for processing:</h4>
    <div id="audio-files"></div>
  </div>
  </body>
</html>
`).window;
global.document = document;
global.window = document.defaultView;

// -----------------
// Mocks
// -----------------
global.Audio = class {};
global.AudioContext = class {};
global.Image = class {};
window.requestAnimationFrame = callback => {
  setTimeout(callback, 0);
};
window.HTMLCanvasElement.prototype.getContext = () => {
  return {
    fillRect: () => {},
    clearRect: () => {},
    getImageData: (x = 0, y = 0, w = 0, h = 0) => ({
      data: new Array(w * h * 4),
    }),
    setLineDash: () => {},
    getLineDash: () => [],
    measureText: (text = '') => ({
      width: 12 * (text.length || 0),
      height: 14,
    }),
    putImageData: () => {},
    createImageData: () => [],
    setTransform: () => {},
    resetTransform: () => {},
    drawImage: () => {},
    save: () => {},
    fillText: () => {},
    restore: () => {},
    beginPath: () => {},
    moveTo: () => {},
    lineTo: () => {},
    closePath: () => {},
    stroke: () => {},
    strokeRect: () => {},
    strokeText: () => {},
    t2: () => {},
    transform: () => {},
    translate: () => {},
    scale: () => {},
    rotate: () => {},
    arc: () => {},
    arcTo: () => {},
    fill: () => {},
    rect: () => {},
    quadraticCurveTo: () => {},
    createLinearGradient: () => ({
      addColorStop: () => {},
    }),
    createPattern: () => ({}),
    createRadialGradient: () => ({
      addColorStop: () => {},
    }),
    bezierCurveTo: () => {},
    drawFocusIfNeeded: () => {},
    clip: () => {},
    ellipse: () => {},
    isPointInPath: () => true,
    isPointInStroke: () => true,
  };
};

// "test": "mocha --reporter min --require esm --require jsdom-global/register -b",
// "test-watch": "mocha --watch --reporter min --require esm --require jsdom-global/register",
