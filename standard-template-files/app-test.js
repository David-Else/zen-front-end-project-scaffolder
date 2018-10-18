const assert = require('assert');
import { test } from '../src/app.js';

document.body.innerHTML = '<div id="app"></div>';

describe('test()', () => {
  const testData = 2;

  it('should return 3 when it has a passed parameter of 2', () => {
    const actual = test(testData);
    const expected = 3;
    assert.strictEqual(actual, expected);
  });
});
