import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  console.log('Run on port -> ', process.env.SERVERPORT);
  await app.listen(process.env.SERVERPORT || 3535);
}
bootstrap();
