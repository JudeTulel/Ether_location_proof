'use client'

import { useRouter } from 'next/navigation'
import { Button } from "@/components/ui/button"

export function AppPickupConfirmationPage() {
  const router = useRouter()

  const handleConfirm = () => {
    // Here you would typically call a smart contract function to confirm pickup
    console.log('Pickup confirmed')
    router.push('/deliver-package')
  }

  return (
    (<div className="container mx-auto px-4 py-8">
      <h1 className="text-3xl font-bold mb-6">Pickup Confirmation</h1>
      <p className="mb-4">Are you sure you want to pick up this package?</p>
      <Button onClick={handleConfirm} className="w-full py-4 text-lg">
        Confirm Pickup
      </Button>
    </div>)
  );
}