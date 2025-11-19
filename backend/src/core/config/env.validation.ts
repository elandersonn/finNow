/* eslint-disable @typescript-eslint/no-unsafe-member-access */
/* eslint-disable @typescript-eslint/no-unsafe-call */
import { z } from 'zod';

const envSchema = z.object({
  // Application
  NODE_ENV: z
    .enum(['development', 'production', 'test'])
    .default('development'),
  PORT: z.string().transform(Number).default(3000),
  APP_URL: z.string().url(),
  FRONTEND_URL: z.string().url(),

  // Database
  DATABASE_URL: z.string().min(1, 'DATABASE_URL is required'),

  // Redis (opcional em desenvolvimento)
  REDIS_HOST: z.string().optional(),
  REDIS_PORT: z.string().transform(Number).optional(),
  REDIS_PASSWORD: z.string().optional(),

  // JWT
  JWT_SECRET: z.string().min(32, 'JWT_SECRET must be at least 32 characters'),
  JWT_EXPIRES_IN: z.string().default('7d'),
  JWT_REFRESH_SECRET: z
    .string()
    .min(32, 'JWT_REFRESH_SECRET must be at least 32 characters'),
  JWT_REFRESH_EXPIRES_IN: z.string().default('30d'),

  // OAuth Google (opcional)
  GOOGLE_CLIENT_ID: z.string().optional(),
  GOOGLE_CLIENT_SECRET: z.string().optional(),
  GOOGLE_CALLBACK_URL: z.string().url().optional(),

  // Email
  EMAIL_HOST: z.string().default('smtp.mailtrap.io'),
  EMAIL_PORT: z.string().transform(Number).default(2525),
  EMAIL_SECURE: z
    .string()
    .transform((val) => val === 'true')
    .default(false),
  EMAIL_USER: z.string().optional(),
  EMAIL_PASSWORD: z.string().optional(),
  EMAIL_FROM: z.string().email().default('noreply@finnow.app'),
  EMAIL_FROM_NAME: z.string().default('finNow'),

  // Upload
  MAX_FILE_SIZE: z.string().transform(Number).default(5242880), // 5MB
  UPLOAD_PATH: z.string().default('./uploads'),

  // Swagger
  SWAGGER_ENABLED: z
    .string()
    .transform((val) => val === 'true')
    .default(true),

  // Rate Limiting
  THROTTLE_TTL: z.string().transform(Number).default(60),
  THROTTLE_LIMIT: z.string().transform(Number).default(10),

  // Security
  BCRYPT_ROUNDS: z.string().transform(Number).default(10),

  // Features
  ENABLE_OAUTH_GOOGLE: z
    .string()
    .transform((val) => val === 'true')
    .default(false),
  ENABLE_EMAIL_VERIFICATION: z
    .string()
    .transform((val) => val === 'true')
    .default(true),
  ENABLE_AUDIT_LOGS: z
    .string()
    .transform((val) => val === 'true')
    .default(true),

  // Frontend URLs (para emails)
  FRONTEND_VERIFY_EMAIL_URL: z.string().url(),
  FRONTEND_RESET_PASSWORD_URL: z.string().url(),
  FRONTEND_INVITATION_URL: z.string().url(),
});

export type EnvConfig = z.infer<typeof envSchema>;
export const env = validateEnv(process.env);

export function validateEnv(config: Record<string, unknown>): EnvConfig {
  try {
    const validatedConfig = envSchema.parse(config);

    console.log('✅ Environment variables validated successfully');

    return validatedConfig;
  } catch (error) {
    if (error instanceof z.ZodError) {
      console.error('❌ Environment validation failed:');
      error.errors.forEach((err) => {
        console.error(`  - ${err.path.join('.')}: ${err.message}`);
      });
    }

    throw new Error('Invalid environment configuration');
  }
}

export const envValidationFactory = {
  validate: validateEnv,
  isGlobal: true,
};
