// 使い方: node src/cli.js sample/sales.csv
'use strict';
const fs = require('fs');
const { parseCsv, sumByMonth } = require('./sales');

const file = process.argv[2];
if (!file) {
  console.error('使い方: node src/cli.js <CSVファイル>');
  process.exit(1);
}
const totals = sumByMonth(parseCsv(fs.readFileSync(file, 'utf8')));
for (const [month, total] of Object.entries(totals)) {
  console.log(`${month}: ${total.toLocaleString()} 円`);
}
