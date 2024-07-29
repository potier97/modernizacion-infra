import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Venta } from './venta.entity';
import { Productos } from './productos.entity';

@Injectable()
export class AppService {
  constructor(
    @InjectRepository(Venta)
    private ventaRepository: Repository<Venta>,
    @InjectRepository(Productos)
    private productosRepository: Repository<Productos>
  ) {}

  async findAll(): Promise<any[]> {
    const results = await this.ventaRepository
      .createQueryBuilder('ventas')
      .select([
        'ventas.id AS id',
        'ventas.vendedor AS vendedor',
        'ventas.total AS total',
        'ventas.fecha AS fecha',
        'cliente.nombre AS cliente',
      ])
      .innerJoin('clientes', 'cliente', 'ventas.cliente = cliente.id')
      .getRawMany();
    return results;
  }

  async findAllProductos(): Promise<any[]> {
    const results = await this.productosRepository
      .createQueryBuilder('productos')
      .select([
        'productos.id AS id',
        'productos.codigo AS codigo',
        'productos.nombre AS nombre',
        'productos.stock AS stock',
        'productos.precio AS precio',
        'productos.proveedor AS id_proveedor',
        'proveedor.nombre AS nombre_proveedor',
      ])
      .innerJoin('proveedor', 'proveedor', 'productos.proveedor = proveedor.id')
      .getRawMany();
    return results;
  }
}
