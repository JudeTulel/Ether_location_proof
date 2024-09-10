'use client';
import { useState, useEffect } from 'react'
import { useRouter } from 'next/navigation'
import { Button } from "@/components/ui/button"
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from "@/components/ui/table"

export function AppAvailableDeliveriesPage() {
  const [packages, setPackages] = useState([])
  const router = useRouter()

  useEffect(() => {
    // Here you would typically fetch available packages from your smart contract
    const fetchPackages = async () => {
      // Simulating API call
      const mockPackages = [
        { id: '1', from: '0x123...', to: '0x456...', postage: '0.1' },
        { id: '2', from: '0x789...', to: '0xabc...', postage: '0.2' },
        { id: '3', from: '0xdef...', to: '0xghi...', postage: '0.15' },
      ]
      setPackages(mockPackages)
    }
    fetchPackages()
  }, [])

  const handlePickup = (packageId) => {
    // Here you would typically call a smart contract function to pick up the package
    const selectedPackage = packages.find(pkg => pkg.id === packageId)
    if (selectedPackage) {
      router.push(
        `/pickup-confirmation?id=${packageId}&from=${selectedPackage.from}&to=${selectedPackage.to}&postage=${selectedPackage.postage}`
      )
    }
  }

  return (
    (<div className="container mx-auto px-4 py-8">
      <h1 className="text-3xl font-bold mb-6">Available Deliveries</h1>
      <Table>
        <TableHeader>
          <TableRow>
            <TableHead>Package ID</TableHead>
            <TableHead>From</TableHead>
            <TableHead>To</TableHead>
            <TableHead>Postage (ETH)</TableHead>
            <TableHead>Action</TableHead>
          </TableRow>
        </TableHeader>
        <TableBody>
          {packages.map((pkg) => (
            <TableRow key={pkg.id}>
              <TableCell>{pkg.id}</TableCell>
              <TableCell>{pkg.from}</TableCell>
              <TableCell>{pkg.to}</TableCell>
              <TableCell>{pkg.postage}</TableCell>
              <TableCell>
                <Button onClick={() => handlePickup(pkg.id)}>
                  Pickup Package
                </Button>
              </TableCell>
            </TableRow>
          ))}
        </TableBody>
      </Table>
    </div>)
  );
}