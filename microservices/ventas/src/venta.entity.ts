import { Entity, Column, PrimaryGeneratedColumn } from 'typeorm';

@Entity()
export class Venta {
  @PrimaryGeneratedColumn()
  id: number;

  @Column()
  cliente: number;

  @Column()
  nombre_cli: string;

  @Column()
  vendedor: string;

  @Column('decimal', { precision: 10, scale: 2 })
  total: number;

  @Column()
  fecha: string;
}
