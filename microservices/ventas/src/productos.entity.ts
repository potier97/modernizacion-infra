import { Entity, Column, PrimaryGeneratedColumn } from 'typeorm';

@Entity({ name: 'productos', schema: 'public' })
export class Productos {
  @PrimaryGeneratedColumn()
  id: number;

  @Column()
  codigo: string;

  @Column()
  nombre: string;

  @Column()
  proveedor: number;

  @Column()
  stock: number;

  @Column()
  precio: number;
}