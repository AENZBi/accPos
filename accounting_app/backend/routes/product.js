const express = require('express');
const Product = require('../models/Product');
const router = express.Router();

// Create Product
router.post('/', async (req, res) => {
  const { name, price, quantity } = req.body;
  const product = new Product({ name, price, quantity });
  try {
    await product.save();
    res.status(201).json(product);
  } catch (error) {
    res.status(500).json({ message: 'Failed to create product', error });
  }
});

// Get all Products
router.get('/', async (req, res) => {
  try {
    const products = await Product.find();
    res.status(200).json(products);
  } catch (error) {
    res.status(500).json({ message: 'Failed to retrieve products', error });
  }
});

module.exports = router;
