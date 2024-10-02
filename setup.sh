#!/bin/bash

# Set variables
PROJECT_NAME="accounting_app"
DB_NAME="accounting_db"

# Create project directory
mkdir $PROJECT_NAME
cd $PROJECT_NAME

# Initialize backend with Node.js
mkdir backend
cd backend
npm init -y

# Install necessary backend packages
npm install express mongoose body-parser cors dotenv jsonwebtoken bcryptjs

# Create the necessary folders and files
mkdir models routes controllers config middleware
touch server.js .env

# Add basic server setup to server.js
cat <<EOL > server.js
const express = require('express');
const mongoose = require('mongoose');
const bodyParser = require('body-parser');
const cors = require('cors');
const dotenv = require('dotenv');

dotenv.config();

const app = express();
app.use(cors());
app.use(bodyParser.json());

// Connect to MongoDB
mongoose.connect(process.env.DB_URI, {
  useNewUrlParser: true,
  useUnifiedTopology: true,
});

// Define routes
app.use('/api/invoices', require('./routes/invoice'));
app.use('/api/products', require('./routes/product'));
app.use('/api/users', require('./routes/user'));

// Start the server
const PORT = process.env.PORT || 5000;
app.listen(PORT, () => console.log(\`Server running on port \${PORT}\`));
EOL

# Add environment variables to .env
cat <<EOL > .env
DB_URI=mongodb://localhost:27017/$DB_NAME
JWT_SECRET=your_jwt_secret
EOL

# Create models
# Invoice Model
cat <<EOL > models/Invoice.js
const mongoose = require('mongoose');

const invoiceSchema = new mongoose.Schema({
  customerName: { type: String, required: true },
  items: [{ name: String, price: Number, quantity: Number }],
  totalAmount: { type: Number, required: true },
  createdAt: { type: Date, default: Date.now }
});

module.exports = mongoose.model('Invoice', invoiceSchema);
EOL

# Product Model
cat <<EOL > models/Product.js
const mongoose = require('mongoose');

const productSchema = new mongoose.Schema({
  name: { type: String, required: true },
  price: { type: Number, required: true },
  quantity: { type: Number, required: true },
  createdAt: { type: Date, default: Date.now }
});

module.exports = mongoose.model('Product', productSchema);
EOL

# User Model
cat <<EOL > models/User.js
const mongoose = require('mongoose');

const userSchema = new mongoose.Schema({
  username: { type: String, required: true, unique: true },
  password: { type: String, required: true },
  role: { type: String, enum: ['admin', 'user'], default: 'user' },
  createdAt: { type: Date, default: Date.now }
});

module.exports = mongoose.model('User', userSchema);
EOL

# Create routes
# Invoice Routes
cat <<EOL > routes/invoice.js
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
EOL

# Product Routes
cat <<EOL > routes/product.js
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
EOL

# User Routes
cat <<EOL > routes/user.js
const express = require('express');
const User = require('../models/User');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const router = express.Router();

// Register User
router.post('/register', async (req, res) => {
  const { username, password } = req.body;
  const hashedPassword = await bcrypt.hash(password, 10);
  const user = new User({ username, password: hashedPassword });
  try {
    await user.save();
    res.status(201).json({ message: 'User created' });
  } catch (error) {
    res.status(500).json({ message: 'Failed to create user', error });
  }
});

// Login User
router.post('/login', async (req, res) => {
  const { username, password } = req.body;
  const user = await User.findOne({ username });
  if (!user || !(await bcrypt.compare(password, user.password))) {
    return res.status(401).json({ message: 'Invalid credentials' });
  }
  const token = jwt.sign({ id: user._id, role: user.role }, process.env.JWT_SECRET);
  res.json({ token });
});

module.exports = router;
EOL

# Navigate back to the project root
cd ..

# Initialize frontend with React
npx create-react-app frontend
cd frontend

# Install necessary frontend packages
npm install axios react-router-dom

# Create a basic folder structure for frontend
mkdir src/components src/pages src/services src/utils

# Add a simple App component
cat <<EOL > src/App.js
import React from 'react';
import { BrowserRouter as Router, Route, Switch } from 'react-router-dom';
import InvoicePage from './pages/InvoicePage';
import ProductPage from './pages/ProductPage';

function App() {
  return (
    <Router>
      <Switch>
        <Route path="/invoices" component={InvoicePage} />
        <Route path="/products" component={ProductPage} />
      </Switch>
    </Router>
  );
}

export default App;
EOL

# Add sample pages for invoices and products
cat <<EOL > src/pages/InvoicePage.js
import React from 'react';

function InvoicePage() {
  return <h1>Invoice Management</h1>;
}

export default InvoicePage;
EOL

cat <<EOL > src/pages/ProductPage.js
import React from 'react';

function ProductPage() {
  return <h1>Product Management</h1>;
}

export default ProductPage;
EOL

# Build the project
echo "Project setup complete. To start the backend, run 'node server.js' in the 'backend' folder."
echo "To start the frontend, run 'npm start' in the 'frontend' folder."
