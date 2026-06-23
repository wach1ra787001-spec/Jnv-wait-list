-- ═══════════════════════════════════════════════════════════════
-- JNV Pro — Waitlist Table
-- Paste into Supabase SQL Editor and click Run
-- ═══════════════════════════════════════════════════════════════

CREATE TABLE IF NOT EXISTS waitlist (
  id                  uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  full_name           text NOT NULL,
  preferred_name      text NOT NULL,
  email               text NOT NULL,
  phone_number        text,
  years_of_experience int  NOT NULL DEFAULT 0,
  markets             text[] NOT NULL DEFAULT '{}',
  does_journal        boolean NOT NULL DEFAULT false,
  journal_duration    text,
  previous_methods    text[] NOT NULL DEFAULT '{}',
  submitted_at        timestamptz NOT NULL DEFAULT now(),
  created_at          timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT waitlist_email_unique UNIQUE (email)
);

CREATE INDEX IF NOT EXISTS idx_waitlist_email     ON waitlist (email);
CREATE INDEX IF NOT EXISTS idx_waitlist_submitted ON waitlist (submitted_at DESC);
CREATE INDEX IF NOT EXISTS idx_waitlist_markets   ON waitlist USING gin (markets);

ALTER TABLE waitlist ENABLE ROW LEVEL SECURITY;

-- Allow anyone to insert (join the waitlist)
CREATE POLICY "public_insert" ON waitlist FOR INSERT WITH CHECK (true);

-- Allow anyone to check if email exists (used by the app)
CREATE POLICY "public_select" ON waitlist FOR SELECT USING (true);
