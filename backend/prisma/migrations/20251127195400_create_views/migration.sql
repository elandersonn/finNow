-- This is an empty migration.-- View: AccountBalance
-- Objetivo: Saldo em tempo real do casal, separado por Carteira e Banco.
-- Otimização: Filtra apenas contas ativas e trata nulos com COALESCE.
CREATE OR REPLACE VIEW "account_balances" AS
SELECT 
    a.id AS account_id,
    COALESCE(SUM(fa.balance), 0) AS total_balance,
    COALESCE(SUM(CASE WHEN fa.type = 'wallet' THEN fa.balance ELSE 0 END), 0) AS wallet_balance,
    COALESCE(SUM(CASE WHEN fa.type = 'bank' THEN fa.balance ELSE 0 END), 0) AS bank_balance
FROM 
    accounts a
LEFT JOIN 
    financial_accounts fa ON a.id = fa.account_id AND fa.is_active = true
GROUP BY 
    a.id;

-- View: MonthlyTransactionSummary
-- Objetivo: Dados para gráficos de evolução (Receita vs Despesa) e fluxo de caixa.
-- Otimização: Agrupa por mês e tipo, calculando totais e médias de uma vez.
CREATE OR REPLACE VIEW "monthly_transaction_summary" AS
SELECT 
    t.account_id,
    DATE_TRUNC('month', t.effective_date) AS "month",
    t.type,
    COUNT(*) AS transaction_count,
    COALESCE(SUM(t.amount), 0) AS total_amount,
    COALESCE(AVG(t.amount), 0) AS average_amount
FROM 
    transactions t
WHERE 
    t.is_effective = true -- Considera apenas o que de fato aconteceu
GROUP BY 
    t.account_id, DATE_TRUNC('month', t.effective_date), t.type;

-- View: SpendingByCategory
-- Objetivo: Dados para o gráfico de Donut de despesas.
-- Otimização: Join direto com categorias para evitar múltiplas queries na aplicação.
CREATE OR REPLACE VIEW "spending_by_category" AS
SELECT 
    t.account_id,
    c.id AS category_id,
    c.name AS category_name,
    c.color AS category_color,
    COUNT(t.id) AS transaction_count,
    COALESCE(SUM(t.amount), 0) AS total_spent,
    DATE_TRUNC('month', t.effective_date) AS "month"
FROM 
    transactions t
JOIN 
    categories c ON t.category_id = c.id
WHERE 
    t.type = 'expense' 
    AND t.is_effective = true
GROUP BY 
    t.account_id, c.id, DATE_TRUNC('month', t.effective_date);