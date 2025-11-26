import { NestFactory } from '@nestjs/core';
import { ValidationPipe } from '@nestjs/common';
import { SwaggerModule, DocumentBuilder } from '@nestjs/swagger';
import helmet from 'helmet';
import { AppModule } from './app.module';
import { AppConfigService } from './core/config/config.service';

async function bootstrap() {
  const app = await NestFactory.create(AppModule, {
    bufferLogs: true,
  });

  const configService = app.get(AppConfigService);

  // Configurar CORS
  app.enableCors({
    //origin: configService.frontendUrl,
    credentials: true,
    methods: ['GET', 'POST', 'PUT', 'PATCH', 'DELETE', 'OPTIONS'],
    allowedHeaders: ['Content-Type', 'Authorization'],
  });

  // Helmet - Segurança HTTP headers
  app.use(helmet());

  // Global prefix
  app.setGlobalPrefix('api');

  // Validation Pipe global
  app.useGlobalPipes(
    new ValidationPipe({
      whitelist: true,
      forbidNonWhitelisted: true,
      transform: true,
      transformOptions: {
        enableImplicitConversion: true,
      },
    }),
  );

  // Swagger - Documentação da API
  if (configService.swaggerEnabled) {
    const config = new DocumentBuilder()
      .setTitle('finNow API')
      .setDescription(
        'API do sistema de gestão financeira para casais - finNow',
      )
      .setVersion('1.0')
      .addBearerAuth(
        {
          type: 'http',
          scheme: 'bearer',
          bearerFormat: 'JWT',
          name: 'JWT',
          description: 'Insira o token JWT',
          in: 'header',
        },
        'JWT-auth',
      )
      .addTag('Auth', 'Endpoints de autenticação')
      .addTag('Users', 'Gerenciamento de usuários')
      .addTag('Accounts', 'Gerenciamento de contas do casal')
      .addTag('Health', 'Health check da aplicação')
      .build();

    const document = SwaggerModule.createDocument(app, config);
    SwaggerModule.setup('api/docs', app, document, {
      customSiteTitle: 'finNow API Documentation',
      customCss: '.swagger-ui .topbar { display: none }',
      swaggerOptions: {
        persistAuthorization: true,
        docExpansion: 'none',
        filter: true,
        showRequestDuration: true,
      },
    });
  }

  await app.listen(configService.port);
}

bootstrap();
