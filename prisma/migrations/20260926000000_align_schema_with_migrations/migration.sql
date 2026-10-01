-- 补齐 schema.prisma 中缺失的迁移（288e033 / 434bb9a 当时只改了 schema，未生成 migration）：
-- 1) shop_orders.clientIp：待支付订单按来源 IP 频控所需列 + 配套复合索引
ALTER TABLE "shop_orders" ADD COLUMN "clientIp" TEXT;
CREATE INDEX "shop_orders_clientIp_status_idx" ON "shop_orders"("clientIp", "status");
--
-- 2) 绑定历史复合索引改名：原名 64 字节，超过 PostgreSQL 标识符 63 字节上限。
--    SQLite 无该限制，但仍与 schema.prisma 保持一致。
DROP INDEX "activation_code_binding_histories_activationCodeId_createdAt_idx";
CREATE INDEX "activation_code_binding_histories_codeId_createdAt_idx" ON "activation_code_binding_histories"("activationCodeId", "createdAt");
