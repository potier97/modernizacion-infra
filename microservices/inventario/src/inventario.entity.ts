import { Entity, Column, PrimaryGeneratedColumn } from 'typeorm';

@Entity()
export class Inventario {
  @PrimaryGeneratedColumn()
  id: number;

  @Column()
  codigo: string;

  @Column()
  nombre: string;

  @Column()
  proveedor: number;

  @Column()
  proveedorPro: string;

  @Column()
  stock: number;

  @Column()
  precio: number;
}
