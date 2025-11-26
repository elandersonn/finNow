export enum UserRole {
  OWNER = 'owner',
  PARTNER = 'partner',
}

export enum AccountStatus {
  ACTIVE = 'active',
  PENDING_PARTNER = 'pending_partner',
  INACTIVE = 'inactive',
}

export enum TransactionType {
  INCOME = 'income',
  EXPENSE = 'expense',
}

export enum PaymentMethod {
  CASH = 'cash',
  PIX = 'pix',
  CARD = 'card',
  SALE = 'sale',
}

export enum AccountType {
  WALLET = 'wallet',
  BANK = 'bank',
}

export enum CurrencyCode {
  BRL = 'BRL',
  USD = 'USD',
  EUR = 'EUR',
}

export enum AlertFrequency {
  DAILY = 'daily',
  INTERVAL = 'interval',
  WEEKLY = 'weekly',
  PERCENTAGE = 'percentage',
}
