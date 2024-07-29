import { Controller, Get } from '@nestjs/common';
import { AppService } from './app.service';
import { Venta } from './venta.entity';
import { Productos } from './productos.entity';

@Controller()
export class AppController {
  constructor(private readonly appService: AppService) {}

  @Get('ventas')
  async getAll(): Promise<Venta[]> {
    return this.appService.findAll();
  }

  @Get('productos')
  async getAllProductos(): Promise<Productos[]> {
    return this.appService.findAllProductos();
  }
}
