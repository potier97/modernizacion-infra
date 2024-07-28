import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { ConfigModule } from '@nestjs/config';
import { Venta } from './venta.entity';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { SQSClient } from '@aws-sdk/client-sqs';
import { SqsModule } from '@ssut/nestjs-sqs';

console.log('process.env.DB_HOST', process.env.DB_HOST);
console.log('process.env.DB_PORT', process.env.DB_PORT);
console.log('process.env.DB_USERNAME', process.env.DB_USERNAME);
console.log('process.env.DB_PASSWORD', process.env.DB_PASSWORD);
console.log('process.env.DB_NAME', process.env.DB_NAME);

@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
      envFilePath: ['.env'],
    }),
    TypeOrmModule.forRootAsync({
      useFactory: async () => ({
        type: 'postgres',
        host: process.env.DATABASE_HOST,
        port: parseInt(process.env.DATABASE_PORT, 10),
        username: process.env.DATABASE_USER,
        password: process.env.DATABASE_PASSWORD,
        database: process.env.DATABASE_NAME,
        synchronize: false,
        ssl: {
          rejectUnauthorized: false,
        },
        entities: [Venta],
        retryDelay: 3000,
        retryAttempts: 5,
      }),
    }),
    TypeOrmModule.forFeature([Venta]),
    SqsModule.register({
      consumers: [
        {
          name: 'inventarioQueue',
          queueUrl: process.env.INVENTARIO_QUEUE_URL,
          region: process.env.AWS_REGION,
          batchSize: 1,
          sqs: new SQSClient({
            region: process.env.AWS_REGION,
            credentials: {
              accessKeyId: process.env.AWS_ACCESS_KEY_ID,
              secretAccessKey: process.env.AWS_SECRET_ACCESS_KEY,
            },
          }),
        },
      ],
      producers: [],
    }),
  ],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
