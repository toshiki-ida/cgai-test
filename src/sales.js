// 売上 CSV（日付,金額）を読み、月ごとの合計を返す小さなサンプル
'use strict';

function parseCsv(text) {
  const lines = text.trim().split(/\r?\n/);
  const rows = [];
  for (const line of lines.slice(1)) {
    if (!line.trim()) continue;
    const [date, amount] = line.split(',');
    rows.push({ date: date.trim(), amount: Number(amount) });
  }
  return rows;
}

function sumByMonth(rows) {
  const totals = {};
  for (const { date, amount } of rows) {
    const month = date.slice(0, 7); // 2026-10
    totals[month] = (totals[month] || 0) + amount;
  }
  return totals;
}

function formatTotals(totals) {
  return Object.entries(totals).map(([month, total]) => `${month}: ${total}`);
}

module.exports = { parseCsv, sumByMonth, formatTotals };
