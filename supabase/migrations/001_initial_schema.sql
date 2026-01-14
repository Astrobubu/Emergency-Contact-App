-- Family Emergency Hub - Initial Database Schema
-- Run this in your Supabase SQL Editor

-- Enable necessary extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- =====================
-- PROFILES (extends auth.users)
-- =====================
CREATE TABLE IF NOT EXISTS public.profiles (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    email TEXT NOT NULL,
    full_name TEXT NOT NULL,
    phone TEXT,
    avatar_url TEXT,
    fcm_token TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- =====================
-- FAMILY GROUPS
-- =====================
CREATE TABLE IF NOT EXISTS public.family_groups (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT NOT NULL,
    description TEXT,
    invite_code TEXT UNIQUE NOT NULL DEFAULT substring(md5(random()::text), 1, 8),
    created_by UUID REFERENCES public.profiles(id) ON DELETE SET NULL,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- =====================
-- FAMILY MEMBERSHIPS
-- =====================
CREATE TABLE IF NOT EXISTS public.family_memberships (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    family_group_id UUID NOT NULL REFERENCES public.family_groups(id) ON DELETE CASCADE,
    role TEXT NOT NULL DEFAULT 'member' CHECK (role IN ('admin', 'member')),
    nickname TEXT,
    joined_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(user_id, family_group_id)
);

-- =====================
-- CONTACTS
-- =====================
CREATE TABLE IF NOT EXISTS public.contacts (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    family_group_id UUID REFERENCES public.family_groups(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    relationship TEXT,
    phone TEXT,
    email TEXT,
    address TEXT,
    notes TEXT,
    category TEXT DEFAULT 'personal' CHECK (category IN ('personal', 'medical', 'emergency', 'other')),
    is_emergency_contact BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- =====================
-- MEDICAL RECORDS
-- =====================
CREATE TABLE IF NOT EXISTS public.medical_records (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    record_type TEXT NOT NULL CHECK (record_type IN ('condition', 'allergy', 'surgery', 'vaccination', 'lab_result', 'other')),
    title TEXT NOT NULL,
    description TEXT,
    date_recorded DATE,
    doctor_name TEXT,
    hospital_name TEXT,
    attachments JSONB DEFAULT '[]',
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- =====================
-- MEDICATIONS
-- =====================
CREATE TABLE IF NOT EXISTS public.medications (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    dosage TEXT NOT NULL,
    frequency TEXT NOT NULL,
    instructions TEXT,
    prescribing_doctor TEXT,
    start_date DATE,
    end_date DATE,
    is_active BOOLEAN DEFAULT TRUE,
    reminder_times JSONB DEFAULT '[]',
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- =====================
-- APPOINTMENTS
-- =====================
CREATE TABLE IF NOT EXISTS public.appointments (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    title TEXT NOT NULL,
    doctor_name TEXT,
    location TEXT,
    appointment_datetime TIMESTAMPTZ NOT NULL,
    duration_minutes INTEGER DEFAULT 60,
    notes TEXT,
    reminder_before_minutes INTEGER DEFAULT 60,
    is_completed BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- =====================
-- EMERGENCY MEDICAL ID
-- =====================
CREATE TABLE IF NOT EXISTS public.emergency_ids (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID UNIQUE NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    blood_type TEXT,
    allergies JSONB DEFAULT '[]',
    conditions JSONB DEFAULT '[]',
    medications JSONB DEFAULT '[]',
    emergency_contacts JSONB DEFAULT '[]',
    organ_donor BOOLEAN,
    medical_notes TEXT,
    is_public BOOLEAN DEFAULT FALSE,
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- =====================
-- INSURANCE DOCUMENTS
-- =====================
CREATE TABLE IF NOT EXISTS public.insurance_documents (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    family_group_id UUID REFERENCES public.family_groups(id) ON DELETE SET NULL,
    insurance_type TEXT NOT NULL CHECK (insurance_type IN ('health', 'life', 'auto', 'home', 'other')),
    provider_name TEXT NOT NULL,
    policy_number TEXT,
    group_number TEXT,
    holder_name TEXT,
    coverage_start DATE,
    coverage_end DATE,
    file_path TEXT NOT NULL,
    file_name TEXT NOT NULL,
    file_size INTEGER,
    mime_type TEXT,
    notes TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- =====================
-- DOCUMENTS VAULT
-- =====================
CREATE TABLE IF NOT EXISTS public.documents (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    family_group_id UUID REFERENCES public.family_groups(id) ON DELETE SET NULL,
    title TEXT NOT NULL,
    category TEXT DEFAULT 'other' CHECK (category IN ('identification', 'legal', 'financial', 'property', 'education', 'other')),
    description TEXT,
    file_path TEXT NOT NULL,
    file_name TEXT NOT NULL,
    file_size INTEGER,
    mime_type TEXT,
    tags JSONB DEFAULT '[]',
    is_shared_with_family BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- =====================
-- EMERGENCY PROTOCOLS
-- =====================
CREATE TABLE IF NOT EXISTS public.emergency_protocols (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    family_group_id UUID NOT NULL REFERENCES public.family_groups(id) ON DELETE CASCADE,
    created_by UUID REFERENCES public.profiles(id) ON DELETE SET NULL,
    title TEXT NOT NULL,
    description TEXT,
    protocol_type TEXT DEFAULT 'general' CHECK (protocol_type IN ('fire', 'medical', 'natural_disaster', 'security', 'general')),
    steps JSONB NOT NULL DEFAULT '[]',
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- =====================
-- LOCATION UPDATES
-- =====================
CREATE TABLE IF NOT EXISTS public.location_updates (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    latitude DOUBLE PRECISION NOT NULL,
    longitude DOUBLE PRECISION NOT NULL,
    accuracy DOUBLE PRECISION,
    altitude DOUBLE PRECISION,
    speed DOUBLE PRECISION,
    heading DOUBLE PRECISION,
    battery_level INTEGER,
    is_charging BOOLEAN,
    timestamp TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_location_updates_user_timestamp
ON public.location_updates(user_id, timestamp DESC);

-- =====================
-- EMERGENCY ALERTS
-- =====================
CREATE TABLE IF NOT EXISTS public.emergency_alerts (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    triggered_by UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    family_group_id UUID NOT NULL REFERENCES public.family_groups(id) ON DELETE CASCADE,
    alert_type TEXT DEFAULT 'emergency' CHECK (alert_type IN ('emergency', 'check_in', 'arrived_safely')),
    message TEXT,
    latitude DOUBLE PRECISION,
    longitude DOUBLE PRECISION,
    address TEXT,
    status TEXT DEFAULT 'active' CHECK (status IN ('active', 'acknowledged', 'resolved')),
    acknowledged_by JSONB DEFAULT '[]',
    resolved_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- =====================
-- REMINDERS
-- =====================
CREATE TABLE IF NOT EXISTS public.reminders (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    reminder_type TEXT NOT NULL CHECK (reminder_type IN ('medication', 'appointment', 'custom')),
    reference_id UUID,
    title TEXT NOT NULL,
    scheduled_at TIMESTAMPTZ NOT NULL,
    is_recurring BOOLEAN DEFAULT FALSE,
    recurrence_rule TEXT,
    is_completed BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_reminders_user_scheduled
ON public.reminders(user_id, scheduled_at);

-- =====================
-- ENABLE RLS
-- =====================
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.family_groups ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.family_memberships ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.contacts ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.medical_records ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.medications ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.appointments ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.emergency_ids ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.insurance_documents ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.documents ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.emergency_protocols ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.location_updates ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.emergency_alerts ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.reminders ENABLE ROW LEVEL SECURITY;

-- =====================
-- RLS POLICIES
-- =====================

-- Profiles
CREATE POLICY "Users can view own profile" ON public.profiles
FOR SELECT TO authenticated USING (auth.uid() = id);

CREATE POLICY "Users can update own profile" ON public.profiles
FOR UPDATE TO authenticated USING (auth.uid() = id);

CREATE POLICY "Users can insert own profile" ON public.profiles
FOR INSERT TO authenticated WITH CHECK (auth.uid() = id);

-- Family groups
CREATE POLICY "Users can view their family groups" ON public.family_groups
FOR SELECT TO authenticated USING (
    id IN (SELECT family_group_id FROM public.family_memberships WHERE user_id = auth.uid())
);

CREATE POLICY "Users can create family groups" ON public.family_groups
FOR INSERT TO authenticated WITH CHECK (created_by = auth.uid());

-- Family memberships
CREATE POLICY "Users can view memberships of their groups" ON public.family_memberships
FOR SELECT TO authenticated USING (
    family_group_id IN (SELECT family_group_id FROM public.family_memberships WHERE user_id = auth.uid())
);

CREATE POLICY "Users can join groups" ON public.family_memberships
FOR INSERT TO authenticated WITH CHECK (user_id = auth.uid());

CREATE POLICY "Users can leave groups" ON public.family_memberships
FOR DELETE TO authenticated USING (user_id = auth.uid());

-- Contacts
CREATE POLICY "Users can manage own contacts" ON public.contacts
FOR ALL TO authenticated USING (user_id = auth.uid()) WITH CHECK (user_id = auth.uid());

-- Medical records
CREATE POLICY "Users can manage own medical records" ON public.medical_records
FOR ALL TO authenticated USING (user_id = auth.uid()) WITH CHECK (user_id = auth.uid());

-- Medications
CREATE POLICY "Users can manage own medications" ON public.medications
FOR ALL TO authenticated USING (user_id = auth.uid()) WITH CHECK (user_id = auth.uid());

-- Appointments
CREATE POLICY "Users can manage own appointments" ON public.appointments
FOR ALL TO authenticated USING (user_id = auth.uid()) WITH CHECK (user_id = auth.uid());

-- Emergency IDs
CREATE POLICY "Users can manage own emergency ID" ON public.emergency_ids
FOR ALL TO authenticated USING (user_id = auth.uid()) WITH CHECK (user_id = auth.uid());

-- Insurance documents
CREATE POLICY "Users can manage own insurance documents" ON public.insurance_documents
FOR ALL TO authenticated USING (user_id = auth.uid()) WITH CHECK (user_id = auth.uid());

-- Documents
CREATE POLICY "Users can manage own documents" ON public.documents
FOR ALL TO authenticated USING (user_id = auth.uid()) WITH CHECK (user_id = auth.uid());

-- Emergency protocols
CREATE POLICY "Family members can view protocols" ON public.emergency_protocols
FOR SELECT TO authenticated USING (
    family_group_id IN (SELECT family_group_id FROM public.family_memberships WHERE user_id = auth.uid())
);

-- Location updates
CREATE POLICY "Users can insert own location" ON public.location_updates
FOR INSERT TO authenticated WITH CHECK (user_id = auth.uid());

CREATE POLICY "Family members can view locations" ON public.location_updates
FOR SELECT TO authenticated USING (
    user_id IN (
        SELECT fm2.user_id FROM public.family_memberships fm1
        JOIN public.family_memberships fm2 ON fm1.family_group_id = fm2.family_group_id
        WHERE fm1.user_id = auth.uid()
    )
);

-- Emergency alerts
CREATE POLICY "Family members can view alerts" ON public.emergency_alerts
FOR SELECT TO authenticated USING (
    family_group_id IN (SELECT family_group_id FROM public.family_memberships WHERE user_id = auth.uid())
);

CREATE POLICY "Users can create alerts in their family groups" ON public.emergency_alerts
FOR INSERT TO authenticated WITH CHECK (
    triggered_by = auth.uid() AND
    family_group_id IN (SELECT family_group_id FROM public.family_memberships WHERE user_id = auth.uid())
);

-- Reminders
CREATE POLICY "Users can manage own reminders" ON public.reminders
FOR ALL TO authenticated USING (user_id = auth.uid()) WITH CHECK (user_id = auth.uid());

-- =====================
-- TRIGGER FOR AUTO-CREATING PROFILE
-- =====================
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO public.profiles (id, email, full_name)
    VALUES (
        NEW.id,
        NEW.email,
        COALESCE(NEW.raw_user_meta_data->>'full_name', split_part(NEW.email, '@', 1))
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
AFTER INSERT ON auth.users
FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- =====================
-- STORAGE BUCKETS
-- =====================
INSERT INTO storage.buckets (id, name, public)
VALUES
    ('avatars', 'avatars', true),
    ('medical-files', 'medical-files', false),
    ('insurance-documents', 'insurance-documents', false),
    ('documents-vault', 'documents-vault', false)
ON CONFLICT (id) DO NOTHING;
