'use client'

import Link from 'next/link'
import { Button } from "@/components/ui/button"

export default function Dashboard() {
  return (
    (<div className="container mx-auto px-4 py-8  bg-red-600">
      <h1 className="text-3xl font-bold mb-6">Dashboard</h1>
      <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
        <Link href="/create-package">
          <Button className="w-full py-4 text-lg">Create Package</Button>
        </Link>
        <Link href="/view-packages">
          <Button className="w-full py-4 text-lg">View Packages</Button>
        </Link>
        <Link href="/track-delivery">
          <Button className="w-full py-4 text-lg">Track Delivery</Button>
        </Link>
      </div>
    </div>)
  );
}