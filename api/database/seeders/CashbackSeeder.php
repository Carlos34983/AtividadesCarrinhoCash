<?php

namespace Database\Seeders;

use App\Models\Customer;
use App\Models\Order;
use Illuminate\Database\Seeder;

class CashbackSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $customer = Customer::factory()->create([
            'cashback_balance' => 0,
        ]);

        Order::factory()->create([
            'customer_id' => $customer->id,
            'total' => 80.00,
            'status' => 'paid',
            'paid_at' => now(),
        ]);

        Order::factory()->create([
            'customer_id' => $customer->id,
            'total' => 300.00,
            'status' => 'paid',
            'paid_at' => now(),
        ]);

        Order::factory()->create([
            'customer_id' => $customer->id,
            'total' => 600.00,
            'status' => 'paid',
            'paid_at' => now(),
        ]);
    }
}
