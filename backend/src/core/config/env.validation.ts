import 'dotenv/config';
import { z } from 'zod';
import { pino } from 'pino';

const logger = pino({
  transport:
    process.env.NODE_ENV !== 'production'
      ? {
          target: 'pino-pretty',
          options: {
            singleLine: true,
            colorize: true,
            translateTime: 'yyyy-mm-dd HH:MM:ss.l',
            ignore: 'pid,hostname',
            messageFormat: '\x1B[31m[EnvValidation]\x1B[0m {msg}',
          },
        }
      : undefined,
});

const envSchema = z.object({
  // Application
  NODE_ENV: z.enum(['development', 'production', 'test']),
  PORT: z.string().transform(Number).default(3000),

  // Database
  DATABASE_URL: z.string().min(1, 'DATABASE_URL is required'),

  // JWT - DESCOMENTE AS LINHAS ABAIXO PARA OBRIGAR A VALIDAÇÃO
  JWT_SECRET: z.string().min(32, 'JWT_SECRET must be at least 32 characters'),
  JWT_EXPIRES_IN: z.string().default('7d'),
  JWT_REFRESH_SECRET: z
    .string()
    .min(32, 'JWT_REFRESH_SECRET must be at least 32 characters'),
  JWT_REFRESH_EXPIRES_IN: z.string().default('30d'),

  // Email
  EMAIL_HOST: z.string().default('smtp.mailtrap.io'),
  EMAIL_PORT: z.string().transform(Number).default(2525),
  EMAIL_SECURE: z
    .string()
    .transform((val) => val === 'true')
    .default(false),
  EMAIL_USER: z.string().optional(),
  EMAIL_PASSWORD: z.string().optional(),
  EMAIL_FROM: z.email().default('noreply@finnow.app'),

  // Upload
  MAX_FILE_SIZE: z.string().transform(Number).default(5242880),
  UPLOAD_PATH: z.string().default('./uploads'),

  // Swagger
  SWAGGER_ENABLED: z
    .string()
    .transform((val) => val === 'true')
    .default(true),

  // Security
  BCRYPT_ROUNDS: z.string().transform(Number).default(10),
});

export type EnvConfig = z.infer<typeof envSchema>;

export function validateEnv(config: Record<string, unknown>): EnvConfig {
  try {
    return envSchema.parse(config);
  } catch (error) {
    if (error instanceof z.ZodError) {
      // Loga formatado usando o Pino
      logger.error({
        msg: 'Environment validation failed',
      });

      // Em dev, iteramos para mostrar bonito no terminal
      if (process.env.NODE_ENV !== 'production') {
        error.issues.forEach((err) => {
          logger.error(`Field: ${err.path.join('.')} - ${err.message}`);
        });
      }
    } else {
      logger.error(
        { err: error },
        'Unexpected error during environment validation',
      );
    }

    process.exit(1);
  }
}
