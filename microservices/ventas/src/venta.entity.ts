import { Entity, Column, PrimaryGeneratedColumn } from 'typeorm';

@Entity({ name: 'ventas', schema: 'public' })
export class Venta {
  @PrimaryGeneratedColumn()
  id: number;

  @Column()
  cliente: number;

  @Column()
  nombre_cli: string;

  @Column()
  vendedor: string;

  @Column('decimal')
  total: number;

  @Column()
  fecha: string;
}
