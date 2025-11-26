-- CreateEnum
CREATE TYPE "UserRole" AS ENUM ('owner', 'partner');

-- CreateEnum
CREATE TYPE "AccountStatus" AS ENUM ('active', 'pending_partner', 'inactive');

-- CreateEnum
CREATE TYPE "TransactionType" AS ENUM ('income', 'expense');

-- CreateEnum
CREATE TYPE "PaymentMethod" AS ENUM ('cash', 'pix', 'card', 'sale');

-- CreateEnum
CREATE TYPE "AccountType" AS ENUM ('wallet', 'bank');

-- CreateEnum
CREATE TYPE "CurrencyCode" AS ENUM ('BRL', 'USD', 'EUR');

-- CreateEnum
CREATE TYPE "AlertFrequency" AS ENUM ('daily', 'interval', 'weekly', 'percentage');

-- CreateTable
CREATE TABLE "users" (
    "id" UUID NOT NULL,
    "email" TEXT NOT NULL,
    "password_hash" TEXT NOT NULL,
    "email_verified" BOOLEAN NOT NULL DEFAULT false,
    "email_verification_token" TEXT,
    "email_verification_expires_at" TIMESTAMPTZ,
    "name" TEXT NOT NULL,
    "nickname" TEXT,
    "nickname_changed_at" TIMESTAMPTZ,
    "nickname_changed_by" UUID,
    "avatar_url" TEXT,
    "avatar_type" TEXT NOT NULL DEFAULT 'predefined',
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "last_login_at" TIMESTAMPTZ,

    CONSTRAINT "users_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "accounts" (
    "id" UUID NOT NULL,
    "status" "AccountStatus" NOT NULL DEFAULT 'pending_partner',
    "default_currency" "CurrencyCode" NOT NULL DEFAULT 'BRL',
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "activated_at" TIMESTAMPTZ,

    CONSTRAINT "accounts_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "account_members" (
    "id" UUID NOT NULL,
    "account_id" UUID NOT NULL,
    "user_id" UUID NOT NULL,
    "role" "UserRole" NOT NULL,
    "invitation_token" TEXT,
    "invitation_sent_at" TIMESTAMPTZ,
    "invitation_accepted_at" TIMESTAMPTZ,
    "joined_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "account_members_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "categories" (
    "id" UUID NOT NULL,
    "account_id" UUID NOT NULL,
    "name" TEXT NOT NULL,
    "color" TEXT NOT NULL,
    "icon" TEXT,
    "transaction_type" "TransactionType" NOT NULL,
    "display_order" INTEGER NOT NULL DEFAULT 0,
    "is_active" BOOLEAN NOT NULL DEFAULT true,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "categories_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "financial_accounts" (
    "id" UUID NOT NULL,
    "account_id" UUID NOT NULL,
    "user_id" UUID,
    "name" TEXT NOT NULL,
    "type" "AccountType" NOT NULL,
    "balance" DECIMAL(15,2) NOT NULL DEFAULT 0.00,
    "initial_balance" DECIMAL(15,2) NOT NULL DEFAULT 0.00,
    "bank_name" TEXT,
    "bank_code" TEXT,
    "currency" "CurrencyCode" NOT NULL DEFAULT 'BRL',
    "is_active" BOOLEAN NOT NULL DEFAULT true,
    "include_in_total" BOOLEAN NOT NULL DEFAULT true,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "financial_accounts_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "transactions" (
    "id" UUID NOT NULL,
    "account_id" UUID NOT NULL,
    "user_id" UUID NOT NULL,
    "category_id" UUID,
    "financial_account_id" UUID,
    "type" "TransactionType" NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT,
    "amount" DECIMAL(15,2) NOT NULL,
    "currency" "CurrencyCode" NOT NULL DEFAULT 'BRL',
    "payment_method" "PaymentMethod",
    "entry_date" DATE NOT NULL,
    "effective_date" DATE NOT NULL,
    "is_effective" BOOLEAN NOT NULL DEFAULT false,
    "is_recurring" BOOLEAN NOT NULL DEFAULT false,
    "recurrence_pattern" TEXT,
    "notes" TEXT,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "transactions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "budgets" (
    "id" UUID NOT NULL,
    "account_id" UUID NOT NULL,
    "category_id" UUID,
    "name" TEXT NOT NULL,
    "target_amount" DECIMAL(15,2) NOT NULL,
    "start_date" DATE NOT NULL,
    "end_date" DATE NOT NULL,
    "enable_alerts" BOOLEAN NOT NULL DEFAULT false,
    "alert_frequency" "AlertFrequency",
    "alert_interval_days" INTEGER,
    "alert_percentage" INTEGER,
    "include_in_forecast" BOOLEAN NOT NULL DEFAULT true,
    "is_active" BOOLEAN NOT NULL DEFAULT true,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "budgets_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "budget_alerts" (
    "id" UUID NOT NULL,
    "budget_id" UUID NOT NULL,
    "alert_type" TEXT NOT NULL,
    "message" TEXT NOT NULL,
    "spent_amount" DECIMAL(15,2) NOT NULL,
    "target_amount" DECIMAL(15,2) NOT NULL,
    "percentage_used" DECIMAL(5,2) NOT NULL,
    "is_read" BOOLEAN NOT NULL DEFAULT false,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "budget_alerts_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "predefined_avatars" (
    "id" UUID NOT NULL,
    "name" TEXT NOT NULL,
    "url" TEXT NOT NULL,
    "category" TEXT,
    "is_active" BOOLEAN NOT NULL DEFAULT true,
    "display_order" INTEGER NOT NULL DEFAULT 0,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "predefined_avatars_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "password_reset_tokens" (
    "id" UUID NOT NULL,
    "user_id" UUID NOT NULL,
    "token" TEXT NOT NULL,
    "expires_at" TIMESTAMPTZ NOT NULL,
    "used" BOOLEAN NOT NULL DEFAULT false,
    "used_at" TIMESTAMPTZ,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "password_reset_tokens_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "audit_logs" (
    "id" UUID NOT NULL,
    "account_id" UUID,
    "user_id" UUID,
    "action" TEXT NOT NULL,
    "entity_type" TEXT NOT NULL,
    "entity_id" UUID,
    "old_data" JSONB,
    "new_data" JSONB,
    "ip_address" TEXT,
    "user_agent" TEXT,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "audit_logs_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "users_email_key" ON "users"("email");

-- CreateIndex
CREATE INDEX "users_email_idx" ON "users"("email");

-- CreateIndex
CREATE INDEX "account_members_account_id_idx" ON "account_members"("account_id");

-- CreateIndex
CREATE INDEX "account_members_user_id_idx" ON "account_members"("user_id");

-- CreateIndex
CREATE INDEX "account_members_invitation_token_idx" ON "account_members"("invitation_token");

-- CreateIndex
CREATE UNIQUE INDEX "account_members_account_id_user_id_key" ON "account_members"("account_id", "user_id");

-- CreateIndex
CREATE INDEX "categories_account_id_idx" ON "categories"("account_id");

-- CreateIndex
CREATE INDEX "categories_transaction_type_idx" ON "categories"("transaction_type");

-- CreateIndex
CREATE UNIQUE INDEX "categories_account_id_name_transaction_type_key" ON "categories"("account_id", "name", "transaction_type");

-- CreateIndex
CREATE INDEX "financial_accounts_account_id_idx" ON "financial_accounts"("account_id");

-- CreateIndex
CREATE INDEX "financial_accounts_user_id_idx" ON "financial_accounts"("user_id");

-- CreateIndex
CREATE INDEX "transactions_account_id_idx" ON "transactions"("account_id");

-- CreateIndex
CREATE INDEX "transactions_user_id_idx" ON "transactions"("user_id");

-- CreateIndex
CREATE INDEX "transactions_category_id_idx" ON "transactions"("category_id");

-- CreateIndex
CREATE INDEX "transactions_financial_account_id_idx" ON "transactions"("financial_account_id");

-- CreateIndex
CREATE INDEX "transactions_type_idx" ON "transactions"("type");

-- CreateIndex
CREATE INDEX "transactions_entry_date_effective_date_idx" ON "transactions"("entry_date", "effective_date");

-- CreateIndex
CREATE INDEX "transactions_is_effective_idx" ON "transactions"("is_effective");

-- CreateIndex
CREATE INDEX "budgets_account_id_idx" ON "budgets"("account_id");

-- CreateIndex
CREATE INDEX "budgets_category_id_idx" ON "budgets"("category_id");

-- CreateIndex
CREATE INDEX "budgets_start_date_end_date_idx" ON "budgets"("start_date", "end_date");

-- CreateIndex
CREATE INDEX "budget_alerts_budget_id_idx" ON "budget_alerts"("budget_id");

-- CreateIndex
CREATE INDEX "budget_alerts_is_read_idx" ON "budget_alerts"("is_read");

-- CreateIndex
CREATE INDEX "predefined_avatars_is_active_idx" ON "predefined_avatars"("is_active");

-- CreateIndex
CREATE UNIQUE INDEX "password_reset_tokens_token_key" ON "password_reset_tokens"("token");

-- CreateIndex
CREATE INDEX "password_reset_tokens_user_id_idx" ON "password_reset_tokens"("user_id");

-- CreateIndex
CREATE INDEX "password_reset_tokens_token_idx" ON "password_reset_tokens"("token");

-- CreateIndex
CREATE INDEX "audit_logs_account_id_idx" ON "audit_logs"("account_id");

-- CreateIndex
CREATE INDEX "audit_logs_user_id_idx" ON "audit_logs"("user_id");

-- CreateIndex
CREATE INDEX "audit_logs_entity_type_entity_id_idx" ON "audit_logs"("entity_type", "entity_id");

-- CreateIndex
CREATE INDEX "audit_logs_created_at_idx" ON "audit_logs"("created_at");

-- AddForeignKey
ALTER TABLE "account_members" ADD CONSTRAINT "account_members_account_id_fkey" FOREIGN KEY ("account_id") REFERENCES "accounts"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "account_members" ADD CONSTRAINT "account_members_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "categories" ADD CONSTRAINT "categories_account_id_fkey" FOREIGN KEY ("account_id") REFERENCES "accounts"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "financial_accounts" ADD CONSTRAINT "financial_accounts_account_id_fkey" FOREIGN KEY ("account_id") REFERENCES "accounts"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "financial_accounts" ADD CONSTRAINT "financial_accounts_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "transactions" ADD CONSTRAINT "transactions_account_id_fkey" FOREIGN KEY ("account_id") REFERENCES "accounts"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "transactions" ADD CONSTRAINT "transactions_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "transactions" ADD CONSTRAINT "transactions_category_id_fkey" FOREIGN KEY ("category_id") REFERENCES "categories"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "transactions" ADD CONSTRAINT "transactions_financial_account_id_fkey" FOREIGN KEY ("financial_account_id") REFERENCES "financial_accounts"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "budgets" ADD CONSTRAINT "budgets_account_id_fkey" FOREIGN KEY ("account_id") REFERENCES "accounts"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "budgets" ADD CONSTRAINT "budgets_category_id_fkey" FOREIGN KEY ("category_id") REFERENCES "categories"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "budget_alerts" ADD CONSTRAINT "budget_alerts_budget_id_fkey" FOREIGN KEY ("budget_id") REFERENCES "budgets"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "password_reset_tokens" ADD CONSTRAINT "password_reset_tokens_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "audit_logs" ADD CONSTRAINT "audit_logs_account_id_fkey" FOREIGN KEY ("account_id") REFERENCES "accounts"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "audit_logs" ADD CONSTRAINT "audit_logs_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;
