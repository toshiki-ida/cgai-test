'use strict';
const test = require('node:test');
const assert = require('node:assert');
const { parseCsv, sumByMonth } = require('../src/sales');

test('CSV を読める', () => {
  const rows = parseCsv('date,amount\n2026-10-01,100\n2026-10-02,200\n');
  assert.deepStrictEqual(rows, [
    { date: '2026-10-01', amount: 100 },
    { date: '2026-10-02', amount: 200 },
  ]);
});

test('月ごとに合計できる', () => {
  const totals = sumByMonth([
    { date: '2026-09-30', amount: 100 },
    { date: '2026-10-01', amount: 200 },
    { date: '2026-10-31', amount: 300 },
  ]);
  assert.deepStrictEqual(totals, { '2026-09': 100, '2026-10': 500 });
});
