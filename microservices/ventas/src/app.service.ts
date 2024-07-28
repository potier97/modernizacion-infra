import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Venta } from './venta.entity';

@Injectable()
export class AppService {
  constructor(
    @InjectRepository(Venta)
    private ventaRepository: Repository<Venta>
  ) {}

  findAll(): Promise<Venta[]> {
    return this.ventaRepository.find();
  }
}
