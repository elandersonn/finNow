import { Module } from '@nestjs/common';
import { LoggerModule as PinoLoggerModule } from 'nestjs-pino';
import { LoggerConfigService } from './logger.config';
import { ConfigModule } from '../config/config.module';

@Module({
  imports: [
    PinoLoggerModule.forRootAsync({
      imports: [ConfigModule],
      providers: [LoggerConfigService],
      inject: [LoggerConfigService],
      useFactory: (loggerConfigService: LoggerConfigService) => {
        return loggerConfigService.createLoggerOptions();
      },
    }),
  ],
  exports: [PinoLoggerModule],
})
export class LoggerModule {}
