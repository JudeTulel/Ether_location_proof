'use client'

import { useState } from 'react'
import { useRouter } from 'next/navigation'
import { Button } from "@/components/ui/button"

export function AppPage() {
  const [isConnecting, setIsConnecting] = useState(false)
  const router = useRouter()

  const connectWallet = async () => {
    setIsConnecting(true)
    try {
      if (typeof window.ethereum !== 'undefined') {
        await window.ethereum.request({ method: 'eth_requestAccounts' })
        router.push('/dashboard')
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
    (<div
      className="flex flex-col items-center justify-center min-h-screen bg-gray-100">
      <h1 className="text-4xl font-bold mb-8">Welcome to Delivery App</h1>
      <Button
        onClick={connectWallet}
        disabled={isConnecting}
        className="px-6 py-3 text-lg">
        {isConnecting ? 'Connecting...' : 'Connect with MetaMask'}
      </Button>
    </div>)
  );
}