<?php
namespace App\Models;
use Illuminate\Database\Eloquent\Factories\HasFactory;
// use Illuminate\Database\Eloquent\Model; // troca esta
use MongoDB\Laravel\Eloquent\Model; // por esta
class Product extends Model
{
 /** @use HasFactory<\Database\Factories\ProductFactory> */
    use HasFactory;
    protected $connection = 'mongodb';
    protected $fillable = [
        'name',
        'description',
        'image',
        'stock',
        'price',
        'attributes',
    ];
 // novo
    protected function casts()
    {
        return [
            'attributes' => 'array',
        ];
    }
}

