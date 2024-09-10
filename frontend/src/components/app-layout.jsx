'use client'

import './globals.css'
import { Inter } from 'next/font/google'

const inter = Inter({ subsets: ['latin'] })

export const metadata = {
  title: 'Delivery App',
  description: 'A decentralized package delivery application',
}

export function AppLayout({
  children
}) {
  return (
    (<html lang="en">
      <body className={inter.className}>{children}</body>
    </html>)
  );
}