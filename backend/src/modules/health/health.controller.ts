import { Controller, Get } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiResponse } from '@nestjs/swagger';
import { PrismaService } from 'src/core/database/prisma/prisma.service';

@ApiTags('Health')
@Controller('health')
export class HealthController {
  constructor(private readonly prisma: PrismaService) {}

  @Get()
  @ApiOperation({ summary: 'Health check da aplicação' })
  @ApiResponse({
    status: 200,
    description: 'Aplicação saudável',
    schema: {
      type: 'object',
      properties: {
        status: { type: 'string', example: 'ok' },
        timestamp: { type: 'string', example: '2024-11-18T10:00:00.000Z' },
        uptime: { type: 'number', example: 12345.67 },
        database: { type: 'string', example: 'connected' },
      },
    },
  })
  async check() {
    // Verificar conexão com banco
    let databaseStatus = 'connected';
    try {
      await this.prisma.$queryRaw`SELECT 1`;
    } catch (error) {
      databaseStatus = 'disconnected';
    }

    return {
      status: 'ok',
      timestamp: new Date().toISOString(),
      uptime: process.uptime(),
      database: databaseStatus,
    };
  }

  @Get('ping')
  @ApiOperation({ summary: 'Ping simples' })
  @ApiResponse({ status: 200, description: 'Pong' })
  ping() {
    return { message: 'pong' };
  }
}
