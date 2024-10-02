const express = require('express');
const Invoice = require('../models/Invoice');
const router = express.Router();

// Create Invoice
router.post('/', async (req, res) => {
  const { customerName, items, totalAmount } = req.body;
  const invoice = new Invoice({ customerName, items, totalAmount });
  try {
    await invoice.save();
    res.status(201).json(invoice);
  } catch (error) {
    res.status(500).json({ message: 'Failed to create invoice', error });
  }
});

// Get all Invoices
router.get('/', async (req, res) => {
  try {
    const invoices = await Invoice.find();
    res.status(200).json(invoices);
  } catch (error) {
    res.status(500).json({ message: 'Failed to retrieve invoices', error });
  }
});

module.exports = router;
