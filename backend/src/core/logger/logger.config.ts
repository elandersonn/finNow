import { Injectable } from '@nestjs/common';
import { Params } from 'nestjs-pino';
import { AppConfigService } from '../config/config.service';
import pinoPretty from 'pino-pretty';
import { SerializedRequest } from 'pino';

const colors = {
  reset: '\x1b[0m',
  green: '\x1b[32m',
  yellow: '\x1b[33m',
  cyan: '\x1b[36m',
  white: '\x1b[37m',
  dim: '\x1b[2m',
};

@Injectable()
export class LoggerConfigService {
  constructor(private readonly configService: AppConfigService) {}

  public createLoggerOptions(): Params {
    const isProduction = this.configService.nodeEnv === 'production';

    const pinoConfig: Params = {
      pinoHttp: {
        level: isProduction ? 'info' : 'debug',
        autoLogging: false,
        serializers: {
          req: (req: SerializedRequest) => ({
            method: req.method,
            url: req.url,
          }),
        },
        customProps: (req) => {
          return req.url!.includes('/health') ? { logLevel: 'silent' } : {};
        },
      },
    };

    if (!isProduction) {
      pinoConfig.pinoHttp = {
        ...pinoConfig.pinoHttp,
        stream: pinoPretty({
          singleLine: true,
          colorize: true,
          colorizeObjects: true,
          ignore: 'pid,hostname,context,req,res,responseTime',

          customPrettifiers: {
            time: (timestamp) => {
              const date = new Date(timestamp as number | string);
              const formattedDate = date.toLocaleString('pt-BR');
              return `${colors.cyan}[${formattedDate}]${colors.reset}`;
            },
          },

          messageFormat: (log: Record<string, unknown>, messageKey: string) => {
            const msg = log[messageKey] as string;

            const context = log.context
              ? `${colors.yellow}[${log.context as string}]${colors.reset}`
              : '';

            return `${context} ${colors.green}${msg}${colors.reset}`;
          },
        }),
      };
    }

    return pinoConfig;
  }
}
