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
