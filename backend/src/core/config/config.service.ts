import { Injectable } from '@nestjs/common';
import { ConfigService as NestConfigService } from '@nestjs/config';
import { EnvConfig } from './env.validation';

@Injectable()
export class AppConfigService {
  constructor(private configService: NestConfigService<EnvConfig, true>) {}

  // Application
  get nodeEnv(): string {
    return this.configService.get('NODE_ENV', { infer: true });
  }

  get port(): number {
    return this.configService.get('PORT', { infer: true });
  }

  // get appUrl(): string {
  //   return this.configService.get('APP_URL', { infer: true });
  // }

  // get frontendUrl(): string {
  //   return this.configService.get('FRONTEND_URL', { infer: true });
  // }

  get isDevelopment(): boolean {
    return this.nodeEnv === 'development';
  }

  get isProduction(): boolean {
    return this.nodeEnv === 'production';
  }

  // Database
  get databaseUrl(): string {
    return this.configService.get('DATABASE_URL', { infer: true });
  }

  // // JWT
  // get jwtSecret(): string {
  //   return this.configService.get('JWT_SECRET', { infer: true });
  // }

  get jwtExpiresIn(): string {
    return this.configService.get('JWT_EXPIRES_IN', { infer: true });
  }

  // get jwtRefreshSecret(): string {
  //   return this.configService.get('JWT_REFRESH_SECRET', { infer: true });
  // }

  get jwtRefreshExpiresIn(): string {
    return this.configService.get('JWT_REFRESH_EXPIRES_IN', { infer: true });
  }

  // Email
  get emailHost(): string {
    return this.configService.get('EMAIL_HOST', { infer: true });
  }

  get emailPort(): number {
    return this.configService.get('EMAIL_PORT', { infer: true });
  }

  get emailSecure(): boolean {
    return this.configService.get('EMAIL_SECURE', { infer: true });
  }

  get emailUser(): string | undefined {
    return this.configService.get('EMAIL_USER', { infer: true });
  }

  get emailPassword(): string | undefined {
    return this.configService.get('EMAIL_PASSWORD', { infer: true });
  }

  get emailFrom(): string {
    return this.configService.get('EMAIL_FROM', { infer: true });
  }

  // Swagger
  get swaggerEnabled(): boolean {
    return this.configService.get('SWAGGER_ENABLED', { infer: true });
  }
}
