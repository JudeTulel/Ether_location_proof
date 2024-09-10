'use client'

import { useState } from 'react'
import { useRouter } from 'next/navigation'
import { Button } from "@/components/ui/button"
import { Input } from "@/components/ui/input"
import { Label } from "@/components/ui/label"

export function AppCreatePackagePage() {
  const [packageDetails, setPackageDetails] = useState({
    packageId: '',
    postage: '',
    minRating: '',
    recipientAddress: ''
  })
  const router = useRouter()

  const handleChange = (e) => {
    setPackageDetails({ ...packageDetails, [e.target.name]: e.target.value })
  }

  const handleSubmit = (e) => {
    e.preventDefault()
    // Here you would typically send this data to your smart contract
    console.log('Package details:', packageDetails)
    router.push('/deposit-funds')
  }

  return (
    (<div className="container mx-auto px-4 py-8">
      <h1 className="text-3xl font-bold mb-6">Create Package</h1>
      <form onSubmit={handleSubmit} className="space-y-4">
        <div>
          <Label htmlFor="packageId">Package ID</Label>
          <Input
            id="packageId"
            name="packageId"
            value={packageDetails.packageId}
            onChange={handleChange}
            required />
        </div>
        <div>
          <Label htmlFor="postage">Postage (ETH)</Label>
          <Input
            id="postage"
            name="postage"
            type="number"
            step="0.001"
            value={packageDetails.postage}
            onChange={handleChange}
            required />
        </div>
        <div>
          <Label htmlFor="minRating">Minimum Delivery Rating</Label>
          <Input
            id="minRating"
            name="minRating"
            type="number"
            value={packageDetails.minRating}
            onChange={handleChange}
            required />
        </div>
        <div>
          <Label htmlFor="recipientAddress">Recipient Wallet Address</Label>
          <Input
            id="recipientAddress"
            name="recipientAddress"
            value={packageDetails.recipientAddress}
            onChange={handleChange}
            required />
        </div>
        <Button type="submit" className="w-full py-4 text-lg">Create Package</Button>
      </form>
    </div>)
  );
}