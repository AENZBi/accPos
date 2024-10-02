const mongoose = require('mongoose');

const invoiceSchema = new mongoose.Schema({
  customerName: { type: String, required: true },
  items: [{ name: String, price: Number, quantity: Number }],
  totalAmount: { type: Number, required: true },
  createdAt: { type: Date, default: Date.now }
});

module.exports = mongoose.model('Invoice', invoiceSchema);
