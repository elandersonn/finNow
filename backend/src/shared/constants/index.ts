export const REGEX = {
  EMAIL: /^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$/,
  PASSWORD:
    /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$/,
  HEX_COLOR: /^#[0-9A-Fa-f]{6}$/,
  UUID: /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i,
};

export const ERROR_MESSAGES = {
  // Auth
  INVALID_CREDENTIALS: 'Email ou senha inválidos',
  EMAIL_ALREADY_EXISTS: 'Este email já está em uso',
  EMAIL_NOT_VERIFIED: 'Email não verificado. Verifique seu email.',
  INVALID_TOKEN: 'Token inválido ou expirado',
  PASSWORDS_DO_NOT_MATCH: 'As senhas não coincidem',
  WEAK_PASSWORD:
    'Senha fraca. Deve conter maiúscula, minúscula, número e caractere especial',

  // Account
  ACCOUNT_NOT_FOUND: 'Conta não encontrada',
  ACCOUNT_NOT_ACTIVE: 'Conta inativa. Convide seu parceiro primeiro.',
  MAX_MEMBERS_REACHED: 'Esta conta já possui 2 membros',
  INVITATION_EXPIRED: 'Convite expirado',
  ALREADY_MEMBER: 'Você já é membro desta conta',

  // General
  NOT_FOUND: 'Recurso não encontrado',
  UNAUTHORIZED: 'Não autorizado',
  FORBIDDEN: 'Acesso negado',
  INTERNAL_ERROR: 'Erro interno do servidor',
};

export const SUCCESS_MESSAGES = {
  EMAIL_SENT: 'Email enviado com sucesso',
  EMAIL_VERIFIED: 'Email verificado com sucesso',
  PASSWORD_RESET: 'Senha redefinida com sucesso',
  INVITATION_SENT: 'Convite enviado com sucesso',
  CREATED: 'Criado com sucesso',
  UPDATED: 'Atualizado com sucesso',
  DELETED: 'Excluído com sucesso',
};

export const METADATA_KEYS = {
  IS_PUBLIC: 'isPublic',
  ROLES: 'roles',
};
