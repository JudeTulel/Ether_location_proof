'use client'
import { useState } from 'react'
import { useNavigate } from 'react-router-dom'
import { Button } from "@/components/ui/button"

export default function MetaMaskLogin() {
  const [isConnecting, setIsConnecting] = useState(false)
  const navigate = useNavigate()

  const connectWallet = async () => {
    setIsConnecting(true)
    try {
      if (typeof window.ethereum !== 'undefined') {
        await window.ethereum.request({ method: 'eth_requestAccounts' })
        navigate('/user-choice')
      } else {
        alert('MetaMask is not installed!')
      }
    } catch (error) {
      console.error('Failed to connect:', error)
      alert('Failed to connect. Please try again.')
    }
    setIsConnecting(false)
  }

  return (
    <div className="flex flex-col items-center justify-center min-h-screen bg-red-600">
      <h1 className="text-4xl font-bold mb-8 ">Welcome to Deli on Chain</h1>
      <Button 
        onClick={connectWallet} 
        disabled={isConnecting}
        className="px-6 py-3 text-lg font-semibold bg-primary text-primary-foreground rounded-lg"
      >
        {isConnecting ? 'Connecting...' : 'Connect with MetaMask'}
      </Button>
    </div>
  )
}