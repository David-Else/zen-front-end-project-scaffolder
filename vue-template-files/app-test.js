import {
  strictEqual,
  notStrictEqual,
  deepStrictEqual,
  notDeepStrictEqual,
  throws,
  doesNotThrow,
} from 'assert';
import { mount } from '@vue/test-utils';
import App from '../src/App.js';

describe('App', () => {
  const wrapper = mount(App);
  const testData = 2;

  it('should return 3 when it has a passed parameter of 2', () => {
    const actual = wrapper.vm.test(testData);
    const expected = 3;
    assert.strictEqual(actual, expected);
  });
});
