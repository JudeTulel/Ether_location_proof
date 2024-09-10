"use client";
import { BrowserRouter as Router, Route, Routes } from 'react-router-dom';
import MetaMaskLogin from './Pages/MetamaskLogin';
import Dashboard from '../components/app-dashboard-page';
import UserChoice from './Pages/UserVariant';
import AppAvailableDeliveriesPage from '@/components/app-available-deliveries-page';

function App() {
  return (
    <Router>
      <Routes>
        <Route path="/" element={<MetaMaskLogin />} />
        <Route path="/dashboard" element={<Dashboard />} />
        <Route path="/create-package" element={<Dashboard />} />
        <Route path="/view-packages" element={<Dashboard />} />
        <Route path="/user-choice" element={<UserChoice/>} />
        <Route path="/deliguy" element={<AppAvailableDeliveriesPage/>} />
      </Routes>
    </Router>
  );
}

export default App;
