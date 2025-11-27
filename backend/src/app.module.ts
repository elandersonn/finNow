import { Module } from '@nestjs/common';
import { ConfigModule } from './core/config/config.module';
import { DatabaseModule } from './core/database/database.module';
import { HealthModule } from './modules/health/health.module';
import { LoggerModule } from './core/logger/logger.module';

@Module({
  imports: [ConfigModule, LoggerModule, DatabaseModule, HealthModule],
  controllers: [],
  providers: [],
})
export class AppModule {}
