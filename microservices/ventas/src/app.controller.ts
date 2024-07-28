import { Controller, Get } from '@nestjs/common';
import { AppService } from './app.service';
import { SqsMessageHandler } from '@ssut/nestjs-sqs';

import { Venta } from './venta.entity';

@Controller()
export class AppController {
  constructor(private readonly appService: AppService) {}

  @Get()
  async getAll(): Promise<Venta[]> {
    return this.appService.findAll();
  }

  @SqsMessageHandler(/** name: */ 'inventarioQueue', /** batch: */ false)
  async handleSqsMessage(message: any): Promise<void> {
    console.log('message', message);
  }
}
