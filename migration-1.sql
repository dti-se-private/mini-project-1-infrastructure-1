-- extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pg_trgm";

-- ddl
DROP TABLE IF EXISTS account CASCADE;
CREATE TABLE account (
    id UUID PRIMARY KEY,
    name TEXT,
    email TEXT UNIQUE,
    password TEXT,
    phone TEXT,
    dob TIMESTAMPTZ,
    referral_code TEXT UNIQUE,
    profile_image_url TEXT
);

DROP TABLE IF EXISTS session CASCADE;
CREATE TABLE session (
    id UUID PRIMARY KEY,
    account_id UUID REFERENCES account(id) ON DELETE CASCADE ON UPDATE CASCADE,
    access_token TEXT UNIQUE,
    refresh_token TEXT UNIQUE,
    access_token_expired_at TIMESTAMPTZ,
    refresh_token_expired_at TIMESTAMPTZ
);

DROP TABLE IF EXISTS voucher CASCADE;
CREATE TABLE voucher (
    id UUID PRIMARY KEY,
    code TEXT UNIQUE,
    name TEXT,
    description TEXT,
    variable_amount NUMERIC,
    started_at TIMESTAMPTZ,
    ended_at TIMESTAMPTZ
);

DROP TABLE IF EXISTS point CASCADE;
CREATE TABLE point (
    id UUID PRIMARY KEY,
    account_id UUID REFERENCES account(id) ON DELETE CASCADE ON UPDATE CASCADE,
    fixed_amount NUMERIC,
    ended_at TIMESTAMPTZ
);

DROP TABLE IF EXISTS event CASCADE;
CREATE TABLE event (
    id UUID PRIMARY KEY,
    account_id UUID REFERENCES account(id) ON DELETE CASCADE ON UPDATE CASCADE,
    name TEXT,
    description TEXT,
    location TEXT,
    category TEXT,
    time TIMESTAMPTZ,
    banner_image_url TEXT
);

DROP TABLE IF EXISTS transaction CASCADE;
CREATE TABLE transaction (
    id UUID PRIMARY KEY,
    event_id UUID REFERENCES event(id) ON DELETE CASCADE ON UPDATE CASCADE,
    account_id UUID REFERENCES account(id) ON DELETE CASCADE ON UPDATE CASCADE,
    time TIMESTAMPTZ
);

DROP TABLE IF EXISTS feedback CASCADE;
CREATE TABLE feedback (
    id UUID PRIMARY KEY,
    transaction_id UUID REFERENCES transaction(id) ON DELETE CASCADE ON UPDATE CASCADE,
    account_id UUID REFERENCES account(id) ON DELETE CASCADE ON UPDATE CASCADE,
    rating NUMERIC,
    review TEXT
);

DROP TABLE IF EXISTS account_voucher CASCADE;
CREATE TABLE account_voucher (
    id UUID PRIMARY KEY,
    account_id UUID REFERENCES account(id) ON DELETE CASCADE ON UPDATE CASCADE,
    voucher_id UUID REFERENCES voucher(id) ON DELETE CASCADE ON UPDATE CASCADE,
    quantity NUMERIC
);

DROP TABLE IF EXISTS event_voucher CASCADE;
CREATE TABLE event_voucher (
    id UUID PRIMARY KEY,
    voucher_id UUID REFERENCES voucher(id) ON DELETE CASCADE ON UPDATE CASCADE,
    event_id UUID REFERENCES event(id) ON DELETE CASCADE ON UPDATE CASCADE
);

DROP TABLE IF EXISTS transaction_voucher CASCADE;
CREATE TABLE transaction_voucher (
    id UUID PRIMARY KEY,
    transaction_id UUID REFERENCES transaction(id) ON DELETE CASCADE ON UPDATE CASCADE,
    voucher_id UUID REFERENCES voucher(id) ON DELETE CASCADE ON UPDATE CASCADE,
    quantity NUMERIC
);

DROP TABLE IF EXISTS transaction_point CASCADE;
CREATE TABLE transaction_point (
    id UUID PRIMARY KEY,
    point_id UUID REFERENCES point(id) ON DELETE CASCADE ON UPDATE CASCADE,
    transaction_id UUID REFERENCES transaction(id) ON DELETE CASCADE ON UPDATE CASCADE,
    fixed_amount NUMERIC
);

DROP TABLE IF EXISTS event_ticket CASCADE;
CREATE TABLE event_ticket (
    id UUID PRIMARY KEY,
    event_id UUID REFERENCES event(id) ON DELETE CASCADE ON UPDATE CASCADE,
    name TEXT,
    description TEXT,
    price NUMERIC,
    slots NUMERIC
);

DROP TABLE IF EXISTS event_ticket_field CASCADE;
CREATE TABLE event_ticket_field (
    id UUID PRIMARY KEY,
    event_ticket_id UUID REFERENCES event_ticket(id) ON DELETE CASCADE ON UPDATE CASCADE,
    key TEXT,
    CONSTRAINT unique_key UNIQUE (event_ticket_id, key)
);

DROP TABLE IF EXISTS transaction_ticket_field CASCADE;
CREATE TABLE transaction_ticket_field (
    id UUID PRIMARY KEY,
    transaction_id UUID REFERENCES transaction(id) ON DELETE CASCADE ON UPDATE CASCADE,
    event_ticket_field_id UUID REFERENCES event_ticket_field(id) ON DELETE CASCADE ON UPDATE CASCADE,
    value TEXT
);

-- dml
INSERT INTO account (id, name, email, password, phone, dob, referral_code, profile_image_url) VALUES
(uuid_generate_v4(), 'admin', 'admin@mail.com', 'b109f3bbbc244eb82441917ed06d618b9008dd09b3befd1b5e07394c706a8bb980b1d7785e5976ec049b46df5f1326af5a2ea6d103fd07c95385ffab0cacbc86', '08123456789', '1990-01-01', 'H7D3F9O1U8', 'https://placehold.co/400x400?text=account0'),
(uuid_generate_v4(), 'Beth', 'beth@mail.com', 'b109f3bbbc244eb82441917ed06d618b9008dd09b3befd1b5e07394c706a8bb980b1d7785e5976ec049b46df5f1326af5a2ea6d103fd07c95385ffab0cacbc86', '08123456780', '1990-02-01', 'G1X4K2J8L1', 'https://placehold.co/400x400?text=account1'),
(uuid_generate_v4(), 'Charles', 'charles@mail.com', 'b109f3bbbc244eb82441917ed06d618b9008dd09b3befd1b5e07394c706a8bb980b1d7785e5976ec049b46df5f1326af5a2ea6d103fd07c95385ffab0cacbc86', '08123456781', '1990-03-01', 'Q8Y6M4P1N2', 'https://placehold.co/400x400?text=account2'),
(uuid_generate_v4(), 'Diana', 'diana@mail.com', 'b109f3bbbc244eb82441917ed06d618b9008dd09b3befd1b5e07394c706a8bb980b1d7785e5976ec049b46df5f1326af5a2ea6d103fd07c95385ffab0cacbc86', '08123456782', '1990-04-01', 'T5R3L1W7H3', 'https://placehold.co/400x400?text=account3'),
(uuid_generate_v4(), 'Edward', 'edward@mail.com', 'b109f3bbbc244eb82441917ed06d618b9008dd09b3befd1b5e07394c706a8bb980b1d7785e5976ec049b46df5f1326af5a2ea6d103fd07c95385ffab0cacbc86', '08123456783', '1990-05-01', 'Z2V8C6J9P4', 'https://placehold.co/400x400?text=account4'),
(uuid_generate_v4(), 'Fiona', 'fiona@mail.com', 'b109f3bbbc244eb82441917ed06d618b9008dd09b3befd1b5e07394c706a8bb980b1d7785e5976ec049b46df5f1326af5a2ea6d103fd07c95385ffab0cacbc86', '08123456784', '1990-06-01', 'B9K7H5T3M5', 'https://placehold.co/400x400?text=account5'),
(uuid_generate_v4(), 'George', 'george@mail.com', 'b109f3bbbc244eb82441917ed06d618b9008dd09b3befd1b5e07394c706a8bb980b1d7785e5976ec049b46df5f1326af5a2ea6d103fd07c95385ffab0cacbc86', '08123456785', '1990-07-01', 'D4W1N8R6L6', 'https://placehold.co/400x400?text=account6'),
(uuid_generate_v4(), 'Hannah', 'hannah@mail.com', 'b109f3bbbc244eb82441917ed06d618b9008dd09b3befd1b5e07394c706a8bb980b1d7785e5976ec049b46df5f1326af5a2ea6d103fd07c95385ffab0cacbc86', '08123456786', '1990-08-01', 'J2P9X3C7F7', 'https://placehold.co/400x400?text=account7'),
(uuid_generate_v4(), 'Isaac', 'isaac@mail.com', 'b109f3bbbc244eb82441917ed06d618b9008dd09b3befd1b5e07394c706a8bb980b1d7785e5976ec049b46df5f1326af5a2ea6d103fd07c95385ffab0cacbc86', '08123456787', '1990-09-01', 'L5T6Z1M3R8', 'https://placehold.co/400x400?text=account8'),
(uuid_generate_v4(), 'Jasmine', 'jasmine@mail.com', 'b109f3bbbc244eb82441917ed06d618b9008dd09b3befd1b5e07394c706a8bb980b1d7785e5976ec049b46df5f1326af5a2ea6d103fd07c95385ffab0cacbc86', '08123456788', '1990-10-01', 'N4V8P2K7Y9', 'https://placehold.co/400x400?text=account9'),
(uuid_generate_v4(), 'Kevin', 'kevin@mail.com', 'b109f3bbbc244eb82441917ed06d618b9008dd09b3befd1b5e07394c706a8bb980b1d7785e5976ec049b46df5f1326af5a2ea6d103fd07c95385ffab0cacbc86', '08123456789', '1990-11-01', 'F1C7H9M5P0', 'https://placehold.co/400x400?text=account10'),
(uuid_generate_v4(), 'Lila', 'lila@mail.com', 'b109f3bbbc244eb82441917ed06d618b9008dd09b3befd1b5e07394c706a8bb980b1d7785e5976ec049b46df5f1326af5a2ea6d103fd07c95385ffab0cacbc86', '08123456790', '1990-12-01', 'H3J2K8L4W9', 'https://placehold.co/400x400?text=account11'),
(uuid_generate_v4(), 'Mark', 'mark@mail.com', 'b109f3bbbc244eb82441917ed06d618b9008dd09b3befd1b5e07394c706a8bb980b1d7785e5976ec049b46df5f1326af5a2ea6d103fd07c95385ffab0cacbc86', '08123456791', '1990-01-02', 'K4M5L8P6N8', 'https://placehold.co/400x400?text=account12'),
(uuid_generate_v4(), 'Nina', 'nina@mail.com', 'b109f3bbbc244eb82441917ed06d618b9008dd09b3befd1b5e07394c706a8bb980b1d7785e5976ec049b46df5f1326af5a2ea6d103fd07c95385ffab0cacbc86', '08123456792', '1990-02-02', 'R7P1V9X3L7', 'https://placehold.co/400x400?text=account13'),
(uuid_generate_v4(), 'Owen', 'owen@mail.com', 'b109f3bbbc244eb82441917ed06d618b9008dd09b3befd1b5e07394c706a8bb980b1d7785e5976ec049b46df5f1326af5a2ea6d103fd07c95385ffab0cacbc86', '08123456793', '1990-03-02', 'Y5T2H6P4J6', 'https://placehold.co/400x400?text=account14'),
(uuid_generate_v4(), 'Paula', 'paula@mail.com', 'b109f3bbbc244eb82441917ed06d618b9008dd09b3befd1b5e07394c706a8bb980b1d7785e5976ec049b46df5f1326af5a2ea6d103fd07c95385ffab0cacbc86', '08123456794', '1990-04-02', 'M3X7K9W2L5', 'https://placehold.co/400x400?text=account15'),
(uuid_generate_v4(), 'Quinn', 'quinn@mail.com', 'b109f3bbbc244eb82441917ed06d618b9008dd09b3befd1b5e07394c706a8bb980b1d7785e5976ec049b46df5f1326af5a2ea6d103fd07c95385ffab0cacbc86', '08123456795', '1990-05-02', 'P4R1D8M6Z4', 'https://placehold.co/400x400?text=account16'),
(uuid_generate_v4(), 'Rita', 'rita@mail.com', 'b109f3bbbc244eb82441917ed06d618b9008dd09b3befd1b5e07394c706a8bb980b1d7785e5976ec049b46df5f1326af5a2ea6d103fd07c95385ffab0cacbc86', '08123456796', '1990-06-02', 'K7W3T2L9H3', 'https://placehold.co/400x400?text=account17'),
(uuid_generate_v4(), 'Sam', 'sam@mail.com', 'b109f3bbbc244eb82441917ed06d618b9008dd09b3befd1b5e07394c706a8bb980b1d7785e5976ec049b46df5f1326af5a2ea6d103fd07c95385ffab0cacbc86', '08123456797', '1990-07-02', 'M8Y6P5J3X2', 'https://placehold.co/400x400?text=account18'),
(uuid_generate_v4(), 'Tina', 'tina@mail.com', 'b109f3bbbc244eb82441917ed06d618b9008dd09b3befd1b5e07394c706a8bb980b1d7785e5976ec049b46df5f1326af5a2ea6d103fd07c95385ffab0cacbc86', '08123456798', '1990-08-02', 'N1V3R9C4P1', 'https://placehold.co/400x400?text=account19'),
(uuid_generate_v4(), 'Ursula', 'ursula@mail.com', 'b109f3bbbc244eb82441917ed06d618b9008dd09b3befd1b5e07394c706a8bb980b1d7785e5976ec049b46df5f1326af5a2ea6d103fd07c95385ffab0cacbc86', '08123456799', '1990-09-02', 'L5T8H7P3K2', 'https://placehold.co/400x400?text=account20'),
(uuid_generate_v4(), 'Victor', 'victor@mail.com', 'b109f3bbbc244eb82441917ed06d618b9008dd09b3befd1b5e07394c706a8bb980b1d7785e5976ec049b46df5f1326af5a2ea6d103fd07c95385ffab0cacbc86', '08123456800', '1990-10-02', 'R6M1P9W4Y3', 'https://placehold.co/400x400?text=account21'),
(uuid_generate_v4(), 'Wendy', 'wendy@mail.com', 'b109f3bbbc244eb82441917ed06d618b9008dd09b3befd1b5e07394c706a8bb980b1d7785e5976ec049b46df5f1326af5a2ea6d103fd07c95385ffab0cacbc86', '08123456801', '1990-11-02', 'X3P7K2H6N4', 'https://placehold.co/400x400?text=account22'),
(uuid_generate_v4(), 'Xander', 'xander@mail.com', 'b109f3bbbc244eb82441917ed06d618b9008dd09b3befd1b5e07394c706a8bb980b1d7785e5976ec049b46df5f1326af5a2ea6d103fd07c95385ffab0cacbc86', '08123456802', '1990-12-02', 'Z2T9P5W1H5', 'https://placehold.co/400x400?text=account23'),
(uuid_generate_v4(), 'Yasmine', 'yasmine@mail.com', 'b109f3bbbc244eb82441917ed06d618b9008dd09b3befd1b5e07394c706a8bb980b1d7785e5976ec049b46df5f1326af5a2ea6d103fd07c95385ffab0cacbc86', '08123456803', '1991-01-01', 'L4J8V3T7M6', 'https://placehold.co/400x400?text=account24'),
(uuid_generate_v4(), 'Zack', 'zack@mail.com', 'b109f3bbbc244eb82441917ed06d618b9008dd09b3befd1b5e07394c706a8bb980b1d7785e5976ec049b46df5f1326af5a2ea6d103fd07c95385ffab0cacbc86', '08123456804', '1991-02-01', 'C7R2P8K5H7', 'https://placehold.co/400x400?text=account25'),
(uuid_generate_v4(), 'Alicia', 'alicia@mail.com', 'b109f3bbbc244eb82441917ed06d618b9008dd09b3befd1b5e07394c706a8bb980b1d7785e5976ec049b46df5f1326af5a2ea6d103fd07c95385ffab0cacbc86', '08123456805', '1991-03-01', 'M1P4T6N3J8', 'https://placehold.co/400x400?text=account26'),
(uuid_generate_v4(), 'Brian', 'brian@mail.com', 'b109f3bbbc244eb82441917ed06d618b9008dd09b3befd1b5e07394c706a8bb980b1d7785e5976ec049b46df5f1326af5a2ea6d103fd07c95385ffab0cacbc86', '08123456806', '1991-04-01', 'W9H5T3P2L9', 'https://placehold.co/400x400?text=account27'),
(uuid_generate_v4(), 'Cindy', 'cindy@mail.com', 'b109f3bbbc244eb82441917ed06d618b9008dd09b3befd1b5e07394c706a8bb980b1d7785e5976ec049b46df5f1326af5a2ea6d103fd07c95385ffab0cacbc86', '08123456807', '1991-05-01', 'H3P7L9W6M0', 'https://placehold.co/400x400?text=account28'),
(uuid_generate_v4(), 'David', 'david@mail.com', 'b109f3bbbc244eb82441917ed06d618b9008dd09b3befd1b5e07394c706a8bb980b1d7785e5976ec049b46df5f1326af5a2ea6d103fd07c95385ffab0cacbc86', '08123456808', '1991-06-01', 'N8T5K2L4P9', 'https://placehold.co/400x400?text=account29');

INSERT INTO session (id, account_id, access_token, refresh_token, access_token_expired_at, refresh_token_expired_at)
SELECT uuid_generate_v4(), id, uuid_generate_v4(), uuid_generate_v4(), now() + interval '1 hour', now() + interval '1 day' 
FROM account;

INSERT INTO voucher (id, code, name, description, variable_amount, started_at, ended_at) VALUES
(uuid_generate_v4(), 'SPRINGSALE2024', 'Spring Sale', 'Get 20% off all items', 0.20, '2024-03-01', '2024-04-30'),
(uuid_generate_v4(), 'SUMMERSAVE2024', 'Summer Save', 'Save 15% on summer collections', 0.15, '2024-06-01', '2024-07-31'),
(uuid_generate_v4(), 'BACK2SCHOOL', 'Back to School', '15% off on school supplies', 0.15, '2024-07-15', '2024-09-30'),
(uuid_generate_v4(), 'WINTERWARMTH', 'Winter Warmth', '30% off winter apparel', 0.30, '2024-11-01', '2025-01-31'),
(uuid_generate_v4(), 'BLACKFRI2024', 'Black Friday', '50% off on selected items', 0.50, '2024-11-28', '2024-12-02'),
(uuid_generate_v4(), 'CYBERMON2024', 'Cyber Monday', '40% off on all tech gadgets', 0.40, '2024-12-02', '2024-12-05'),
(uuid_generate_v4(), 'XMASJOY2024', 'Christmas Joy', '25% off sitewide', 0.25, '2024-12-10', '2024-12-31'),
(uuid_generate_v4(), 'NYEAR2025', 'New Year Special', 'Start the year with 20% off', 0.20, '2025-01-01', '2025-01-10'),
(uuid_generate_v4(), 'LOVE2025', 'Valentine Love', '15% off gifts for your loved ones', 0.15, '2025-02-01', '2025-02-14'),
(uuid_generate_v4(), 'SPRINGBLOOM2025', 'Spring Bloom', '25% off on all garden products', 0.25, '2025-03-01', '2025-04-30'),
(uuid_generate_v4(), 'EASTER2025', 'Easter Special', '20% off on Easter goodies', 0.20, '2025-04-01', '2025-04-15'),
(uuid_generate_v4(), 'MAYDAY2025', 'May Day Discount', '15% off on outdoor equipment', 0.15, '2025-05-01', '2025-05-31'),
(uuid_generate_v4(), 'SUMMERFUN2025', 'Summer Fun', 'Save 20% on summer fun items', 0.20, '2025-06-01', '2025-07-31'),
(uuid_generate_v4(), 'BACK2SCHOOL2025', 'Back to School', '10% off on all school supplies', 0.10, '2025-08-01', '2025-09-30'),
(uuid_generate_v4(), 'AUTUMN2025', 'Autumn Sale', '30% off on all autumn wear', 0.30, '2025-09-01', '2025-10-31'),
(uuid_generate_v4(), 'HALLOWEEN2025', 'Halloween Special', 'Get 25% off spooky costumes', 0.25, '2025-10-01', '2025-10-31'),
(uuid_generate_v4(), 'THANKS2025', 'Thanksgiving Treat', '20% off on home essentials', 0.20, '2025-11-15', '2025-11-29'),
(uuid_generate_v4(), 'HOLIDAY2025', 'Holiday Sale', '15% off on holiday decor', 0.15, '2025-12-01', '2025-12-25'),
(uuid_generate_v4(), 'NYE2025', 'New Year Eve Bash', '25% off on party items', 0.25, '2025-12-26', '2026-01-01'),
(uuid_generate_v4(), 'WINTER2025', 'Winter Wonderland', '20% off on all winter gear', 0.20, '2025-12-01', '2026-02-28'),
(uuid_generate_v4(), 'SAVEBIG2026', 'Save Big', 'Get 10% off on bulk purchases', 0.10, '2026-01-01', '2026-01-31'),
(uuid_generate_v4(), 'LOVE2026', 'Valentine Special', '20% off on gifts', 0.20, '2026-02-01', '2026-02-14'),
(uuid_generate_v4(), 'SPRINGFLING2026', 'Spring Fling', '15% off all spring items', 0.15, '2026-03-01', '2026-04-30'),
(uuid_generate_v4(), 'SUMMERVIBES2026', 'Summer Vibes', 'Enjoy 25% off on summer essentials', 0.25, '2026-06-01', '2026-07-31'),
(uuid_generate_v4(), 'BTS2026', 'Back to School', '10% off on school accessories', 0.10, '2026-08-01', '2026-09-30'),
(uuid_generate_v4(), 'HARVEST2026', 'Harvest Sale', '30% off on autumn collection', 0.30, '2026-09-01', '2026-10-31'),
(uuid_generate_v4(), 'SPOOKY2026', 'Spooky Sale', '20% off on Halloween items', 0.20, '2026-10-01', '2026-10-31'),
(uuid_generate_v4(), 'FEAST2026', 'Feast Fest', '25% off on cooking essentials', 0.25, '2026-11-01', '2026-11-30'),
(uuid_generate_v4(), 'FESTIVE2026', 'Festive Cheer', '15% off on holiday treats', 0.15, '2026-12-01', '2026-12-31'),
(uuid_generate_v4(), 'NEWYEAR2026', 'New Year Celebration', '20% off on celebration supplies', 0.20, '2026-12-26', '2027-01-05');

INSERT INTO point (id, account_id, fixed_amount, ended_at)
SELECT uuid_generate_v4(), id, floor(random() * 10001), now() + interval '3 months' 
FROM account;

INSERT INTO event (id, account_id, name, description, location, category, time, banner_image_url) VALUES
(uuid_generate_v4(), (SELECT id FROM account LIMIT 1 OFFSET 0), 'Music Festival', 'An outdoor music festival with various artists.', 'JIExpo Kemayoran, Jakarta, Indonesia', 'Entertainment', '2024-12-01T18:00:00+00:00', 'https://placehold.co/1366x768?text=event0'),
(uuid_generate_v4(), (SELECT id FROM account LIMIT 1 OFFSET 0), 'Art Exhibition', 'An exhibition showcasing modern art.', 'National Gallery of Indonesia, Jakarta', 'Art', '2025-01-15T10:00:00+00:00', 'https://placehold.co/1366x768?text=event1'),
(uuid_generate_v4(), (SELECT id FROM account LIMIT 1 OFFSET 0), 'Tech Conference', 'Annual conference for tech enthusiasts.', 'Bandung Institute of Technology, Bandung, Indonesia', 'Conference', '2025-02-20T09:00:00+00:00', 'https://placehold.co/1366x768?text=event2'),
(uuid_generate_v4(), (SELECT id FROM account LIMIT 1 OFFSET 0), 'Cooking Workshop', 'Hands-on cooking workshop with a celebrity chef.', 'Arkamaya Seminyak, Bali, Indonesia', 'Workshop', '2025-03-05T14:00:00+00:00', 'https://placehold.co/1366x768?text=event3'),
(uuid_generate_v4(), (SELECT id FROM account LIMIT 1 OFFSET 0), 'Charity Run', 'A 5K run to raise funds for charity.', 'Gelora Bung Karno Stadium, Jakarta', 'Sports', '2025-04-10T07:00:00+00:00', 'https://placehold.co/1366x768?text=event4'),
(uuid_generate_v4(), (SELECT id FROM account LIMIT 1 OFFSET 0), 'Book Launch', 'Launch event for a new book by a bestselling author.', 'Kinokuniya Plaza Senayan, Jakarta', 'Literature', '2025-05-01T18:30:00+00:00', 'https://placehold.co/1366x768?text=event5'),
(uuid_generate_v4(), (SELECT id FROM account LIMIT 1 OFFSET 0), 'Yoga Retreat', 'A weekend retreat focusing on yoga and wellness.', 'The Yoga Barn, Ubud, Bali', 'Health', '2025-06-15T08:00:00+00:00', 'https://placehold.co/1366x768?text=event6'),
(uuid_generate_v4(), (SELECT id FROM account LIMIT 1 OFFSET 0), 'Film Screening', 'Special screening of an indie film.', 'CGV Grand Indonesia, Jakarta', 'Entertainment', '2025-07-20T20:00:00+00:00', 'https://placehold.co/1366x768?text=event7'),
(uuid_generate_v4(), (SELECT id FROM account LIMIT 1 OFFSET 0), 'Science Fair', 'Annual science fair showcasing student projects.', 'Universitas Indonesia, Depok', 'Education', '2025-08-10T09:00:00+00:00', 'https://placehold.co/1366x768?text=event8'),
(uuid_generate_v4(), (SELECT id FROM account LIMIT 1 OFFSET 0), 'Gardening Workshop', 'Learn about urban gardening techniques.', 'Taman Menteng, Jakarta', 'Workshop', '2025-09-05T13:00:00+00:00', 'https://placehold.co/1366x768?text=event9'),
(uuid_generate_v4(), (SELECT id FROM account LIMIT 1 OFFSET 1), 'Dance Performance', 'A contemporary dance performance.', 'Teater Jakarta, Taman Ismail Marzuki, Jakarta',  'Entertainment', '2025-10-01T19:00:00+00:00', 'https://placehold.co/1366x768?text=event10'),
(uuid_generate_v4(), (SELECT id FROM account LIMIT 1 OFFSET 1), 'Business Meetup', 'Networking event for business professionals.', 'The Ritz-Carlton Jakarta, Pacific Place', 'Networking', '2025-11-15T17:00:00+00:00', 'https://placehold.co/1366x768?text=event11'),
(uuid_generate_v4(), (SELECT id FROM account LIMIT 1 OFFSET 1), 'Photography Exhibition', 'Exhibition featuring travel photography.', 'Dia.Lo.Gue Artspace, Kemang, Jakarta', 'Art', '2025-12-20T11:00:00+00:00', 'https://placehold.co/1366x768?text=event12'),
(uuid_generate_v4(), (SELECT id FROM account LIMIT 1 OFFSET 1), 'Fitness Bootcamp', 'Intense fitness bootcamp session.', 'Taman Suropati, Jakarta', 'Health', '2026-01-05T06:00:00+00:00', 'https://placehold.co/1366x768?text=event13'),
(uuid_generate_v4(), (SELECT id FROM account LIMIT 1 OFFSET 1), 'Cooking Class', 'Learn to cook traditional dishes.', 'Amuz Gourmet Restaurant, Jakarta', 'Workshop', '2026-02-12T14:00:00+00:00', 'https://placehold.co/1366x768?text=event14'),
(uuid_generate_v4(), (SELECT id FROM account LIMIT 1 OFFSET 1), 'Career Fair', 'Career fair for recent graduates.', 'Jakarta Convention Center', 'Education', '2026-03-10T10:00:00+00:00', 'https://placehold.co/1366x768?text=event15'),
(uuid_generate_v4(), (SELECT id FROM account LIMIT 1 OFFSET 1), 'Music Concert', 'Live concert by a popular band.', 'ICE BSD, Tangerang', 'Entertainment', '2026-04-25T20:00:00+00:00', 'https://placehold.co/1366x768?text=event16'),
(uuid_generate_v4(), (SELECT id FROM account LIMIT 1 OFFSET 1), 'Theater Play', 'Local theater group performing a classic play.', 'Gedung Kesenian Jakarta', 'Entertainment', '2026-05-18T19:30:00+00:00', 'https://placehold.co/1366x768?text=event17'),
(uuid_generate_v4(), (SELECT id FROM account LIMIT 1 OFFSET 1), 'Workshop on Coding', 'Introductory workshop on programming.', 'Google Indonesia, Jakarta', 'Education', '2026-06-07T09:00:00+00:00', 'https://placehold.co/1366x768?text=event18'),
(uuid_generate_v4(), (SELECT id FROM account LIMIT 1 OFFSET 1), 'Environmental Seminar', 'Seminar on climate change and sustainability.', 'The Dharmawangsa Jakarta', 'Education', '2026-07-22T14:00:00+00:00', 'https://placehold.co/1366x768?text=event19'),
(uuid_generate_v4(), (SELECT id FROM account LIMIT 1 OFFSET 2), 'Food Festival', 'A festival celebrating local cuisine.', 'Grand Indonesia Shopping Town, Jakarta', 'Entertainment', '2026-08-30T12:00:00+00:00', 'https://placehold.co/1366x768?text=event20'),
(uuid_generate_v4(), (SELECT id FROM account LIMIT 1 OFFSET 2), 'Mindfulness Retreat', 'A weekend retreat focusing on mindfulness and meditation.', 'Fivelements, Bali', 'Health', '2026-09-18T08:00:00+00:00', 'https://placehold.co/1366x768?text=event21'),
(uuid_generate_v4(), (SELECT id FROM account LIMIT 1 OFFSET 2), 'Charity Gala', 'A gala event to raise funds for charity.', 'Hotel Mulia Senayan, Jakarta', 'Networking', '2026-10-10T18:00:00+00:00', 'https://placehold.co/1366x768?text=event22'),
(uuid_generate_v4(), (SELECT id FROM account LIMIT 1 OFFSET 2), 'Cultural Festival', 'A festival celebrating diverse cultures.', 'Taman Mini Indonesia Indah, Jakarta', 'Entertainment', '2026-11-05T10:00:00+00:00', 'https://placehold.co/1366x768?text=event23'),
(uuid_generate_v4(), (SELECT id FROM account LIMIT 1 OFFSET 2), 'Public Speaking Workshop', 'Improve your public speaking skills.', 'Senayan City, Jakarta', 'Workshop', '2026-12-01T09:00:00+00:00', 'https://placehold.co/1366x768?text=event24'),
(uuid_generate_v4(), (SELECT id FROM account LIMIT 1 OFFSET 2), 'Product Launch', 'Launch event for a new tech product.', ' Ritz-Carlton Mega Kuningan, Jakarta', 'Conference', '2026-12-15T15:00:00+00:00', 'https://placehold.co/1366x768?text=event25'),
(uuid_generate_v4(), (SELECT id FROM account LIMIT 1 OFFSET 2), 'Art Fair', 'A fair showcasing local artists and their work.', 'ARTJOG, Yogyakarta', 'Art', '2027-01-20T10:00:00+00:00', 'https://placehold.co/1366x768?text=event26'),
(uuid_generate_v4(), (SELECT id FROM account LIMIT 1 OFFSET 2), 'Writing Workshop', 'Workshop on creative writing techniques.', 'IVAA (Indonesian Visual Art Archive), Yogyakarta', 'Workshop', '2027-02-05T14:00:00+00:00', 'https://placehold.co/1366x768?text=event27'),
(uuid_generate_v4(), (SELECT id FROM account LIMIT 1 OFFSET 2), 'Health Fair', 'A fair promoting health and wellness.', 'Mall Kelapa Gading, Jakarta', 'Health', '2027-03-10T08:00:00+00:00', 'https://placehold.co/1366x768?text=event28'),
(uuid_generate_v4(), (SELECT id FROM account LIMIT 1 OFFSET 2), 'Innovation Summit', 'Summit on innovation and entrepreneurship.', 'Block71 Jakarta', 'Conference', '2027-04-25T09:00:00+00:00', 'https://placehold.co/1366x768?text=event29');
INSERT INTO transaction (id, event_id, account_id, time) VALUES
(uuid_generate_v4(), (SELECT id FROM event LIMIT 1 OFFSET 0), (SELECT id FROM account LIMIT 1 OFFSET 0), now() - interval '1 day'),
(uuid_generate_v4(), (SELECT id FROM event LIMIT 1 OFFSET 1), (SELECT id FROM account LIMIT 1 OFFSET 1), now() - interval '2 day'),
(uuid_generate_v4(), (SELECT id FROM event LIMIT 1 OFFSET 2), (SELECT id FROM account LIMIT 1 OFFSET 2), now() - interval '3 day'),
(uuid_generate_v4(), (SELECT id FROM event LIMIT 1 OFFSET 3), (SELECT id FROM account LIMIT 1 OFFSET 3), now() - interval '4 day'),
(uuid_generate_v4(), (SELECT id FROM event LIMIT 1 OFFSET 4), (SELECT id FROM account LIMIT 1 OFFSET 4), now() - interval '5 day'),
(uuid_generate_v4(), (SELECT id FROM event LIMIT 1 OFFSET 5), (SELECT id FROM account LIMIT 1 OFFSET 5), now() - interval '6 day'),
(uuid_generate_v4(), (SELECT id FROM event LIMIT 1 OFFSET 6), (SELECT id FROM account LIMIT 1 OFFSET 6), now() - interval '7 day'),
(uuid_generate_v4(), (SELECT id FROM event LIMIT 1 OFFSET 7), (SELECT id FROM account LIMIT 1 OFFSET 7), now() - interval '8 day'),
(uuid_generate_v4(), (SELECT id FROM event LIMIT 1 OFFSET 8), (SELECT id FROM account LIMIT 1 OFFSET 8), now() - interval '9 day'),
(uuid_generate_v4(), (SELECT id FROM event LIMIT 1 OFFSET 9), (SELECT id FROM account LIMIT 1 OFFSET 9), now() - interval '10 day'),
(uuid_generate_v4(), (SELECT id FROM event LIMIT 1 OFFSET 0), (SELECT id FROM account LIMIT 1 OFFSET 10), now() - interval '11 day'),
(uuid_generate_v4(), (SELECT id FROM event LIMIT 1 OFFSET 1), (SELECT id FROM account LIMIT 1 OFFSET 11), now() - interval '12 day'),
(uuid_generate_v4(), (SELECT id FROM event LIMIT 1 OFFSET 2), (SELECT id FROM account LIMIT 1 OFFSET 12), now() - interval '13 day'),
(uuid_generate_v4(), (SELECT id FROM event LIMIT 1 OFFSET 3), (SELECT id FROM account LIMIT 1 OFFSET 13), now() - interval '14 day'),
(uuid_generate_v4(), (SELECT id FROM event LIMIT 1 OFFSET 4), (SELECT id FROM account LIMIT 1 OFFSET 14), now() - interval '15 day'),
(uuid_generate_v4(), (SELECT id FROM event LIMIT 1 OFFSET 5), (SELECT id FROM account LIMIT 1 OFFSET 15), now() - interval '16 day'),
(uuid_generate_v4(), (SELECT id FROM event LIMIT 1 OFFSET 6), (SELECT id FROM account LIMIT 1 OFFSET 16), now() - interval '17 day'),
(uuid_generate_v4(), (SELECT id FROM event LIMIT 1 OFFSET 7), (SELECT id FROM account LIMIT 1 OFFSET 17), now() - interval '18 day'),
(uuid_generate_v4(), (SELECT id FROM event LIMIT 1 OFFSET 8), (SELECT id FROM account LIMIT 1 OFFSET 18), now() - interval '19 day'),
(uuid_generate_v4(), (SELECT id FROM event LIMIT 1 OFFSET 9), (SELECT id FROM account LIMIT 1 OFFSET 19), now() - interval '20 day'),
(uuid_generate_v4(), (SELECT id FROM event LIMIT 1 OFFSET 0), (SELECT id FROM account LIMIT 1 OFFSET 20), now() - interval '21 day'),
(uuid_generate_v4(), (SELECT id FROM event LIMIT 1 OFFSET 1), (SELECT id FROM account LIMIT 1 OFFSET 21), now() - interval '22 day'),
(uuid_generate_v4(), (SELECT id FROM event LIMIT 1 OFFSET 2), (SELECT id FROM account LIMIT 1 OFFSET 22), now() - interval '23 day'),
(uuid_generate_v4(), (SELECT id FROM event LIMIT 1 OFFSET 3), (SELECT id FROM account LIMIT 1 OFFSET 23), now() - interval '24 day'),
(uuid_generate_v4(), (SELECT id FROM event LIMIT 1 OFFSET 4), (SELECT id FROM account LIMIT 1 OFFSET 24), now() - interval '25 day'),
(uuid_generate_v4(), (SELECT id FROM event LIMIT 1 OFFSET 5), (SELECT id FROM account LIMIT 1 OFFSET 25), now() - interval '26 day'),
(uuid_generate_v4(), (SELECT id FROM event LIMIT 1 OFFSET 6), (SELECT id FROM account LIMIT 1 OFFSET 26), now() - interval '27 day'),
(uuid_generate_v4(), (SELECT id FROM event LIMIT 1 OFFSET 7), (SELECT id FROM account LIMIT 1 OFFSET 27), now() - interval '28 day'),
(uuid_generate_v4(), (SELECT id FROM event LIMIT 1 OFFSET 8), (SELECT id FROM account LIMIT 1 OFFSET 28), now() - interval '29 day'),
(uuid_generate_v4(), (SELECT id FROM event LIMIT 1 OFFSET 9), (SELECT id FROM account LIMIT 1 OFFSET 29), now() - interval '30 day');
INSERT INTO feedback (id, transaction_id, account_id, rating, review) VALUES
(uuid_generate_v4(), (SELECT id FROM transaction LIMIT 1 OFFSET 0), (SELECT id FROM account LIMIT 1 OFFSET 0), 5, 'Excellent service! Highly recommend.'),
(uuid_generate_v4(), (SELECT id FROM transaction LIMIT 1 OFFSET 1), (SELECT id FROM account LIMIT 1 OFFSET 1), 4, 'Very good, but room for improvement.'),
(uuid_generate_v4(), (SELECT id FROM transaction LIMIT 1 OFFSET 2), (SELECT id FROM account LIMIT 1 OFFSET 2), 3, 'Average experience, nothing special.'),
(uuid_generate_v4(), (SELECT id FROM transaction LIMIT 1 OFFSET 3), (SELECT id FROM account LIMIT 1 OFFSET 3), 2, 'Not satisfied with the service.'),
(uuid_generate_v4(), (SELECT id FROM transaction LIMIT 1 OFFSET 4), (SELECT id FROM account LIMIT 1 OFFSET 4), 1, 'Very poor service, would not recommend.'),
(uuid_generate_v4(), (SELECT id FROM transaction LIMIT 1 OFFSET 5), (SELECT id FROM account LIMIT 1 OFFSET 5), 4, 'Good service but can improve.'),
(uuid_generate_v4(), (SELECT id FROM transaction LIMIT 1 OFFSET 6), (SELECT id FROM account LIMIT 1 OFFSET 6), 5, 'Fantastic experience! Will use again.'),
(uuid_generate_v4(), (SELECT id FROM transaction LIMIT 1 OFFSET 7), (SELECT id FROM account LIMIT 1 OFFSET 7), 3, 'Okay service, not great but not bad.'),
(uuid_generate_v4(), (SELECT id FROM transaction LIMIT 1 OFFSET 8), (SELECT id FROM account LIMIT 1 OFFSET 8), 4, 'Good value for the money.'),
(uuid_generate_v4(), (SELECT id FROM transaction LIMIT 1 OFFSET 9), (SELECT id FROM account LIMIT 1 OFFSET 9), 5, 'Excellent! Very pleased with the service.'),
(uuid_generate_v4(), (SELECT id FROM transaction LIMIT 1 OFFSET 10), (SELECT id FROM account LIMIT 1 OFFSET 0), 2, 'Below average experience.'),
(uuid_generate_v4(), (SELECT id FROM transaction LIMIT 1 OFFSET 11), (SELECT id FROM account LIMIT 1 OFFSET 1), 1, 'Terrible service, will not return.'),
(uuid_generate_v4(), (SELECT id FROM transaction LIMIT 1 OFFSET 12), (SELECT id FROM account LIMIT 1 OFFSET 2), 4, 'Quite good, would recommend.'),
(uuid_generate_v4(), (SELECT id FROM transaction LIMIT 1 OFFSET 13), (SELECT id FROM account LIMIT 1 OFFSET 3), 5, 'Excellent and prompt service!'),
(uuid_generate_v4(), (SELECT id FROM transaction LIMIT 1 OFFSET 14), (SELECT id FROM account LIMIT 1 OFFSET 4), 3, 'Average, could be better.'),
(uuid_generate_v4(), (SELECT id FROM transaction LIMIT 1 OFFSET 15), (SELECT id FROM account LIMIT 1 OFFSET 5), 4, 'Good, but had a few issues.'),
(uuid_generate_v4(), (SELECT id FROM transaction LIMIT 1 OFFSET 16), (SELECT id FROM account LIMIT 1 OFFSET 6), 5, 'Perfect! Couldn’t ask for more.'),
(uuid_generate_v4(), (SELECT id FROM transaction LIMIT 1 OFFSET 17), (SELECT id FROM account LIMIT 1 OFFSET 7), 2, 'Not what I expected, disappointed.'),
(uuid_generate_v4(), (SELECT id FROM transaction LIMIT 1 OFFSET 18), (SELECT id FROM account LIMIT 1 OFFSET 8), 1, 'Horrible experience overall.'),
(uuid_generate_v4(), (SELECT id FROM transaction LIMIT 1 OFFSET 19), (SELECT id FROM account LIMIT 1 OFFSET 9), 4, 'Pretty good service.'),
(uuid_generate_v4(), (SELECT id FROM transaction LIMIT 1 OFFSET 20), (SELECT id FROM account LIMIT 1 OFFSET 0), 5, 'Excellent service, highly recommend.'),
(uuid_generate_v4(), (SELECT id FROM transaction LIMIT 1 OFFSET 21), (SELECT id FROM account LIMIT 1 OFFSET 1), 3, 'It was okay, not great.'),
(uuid_generate_v4(), (SELECT id FROM transaction LIMIT 1 OFFSET 22), (SELECT id FROM account LIMIT 1 OFFSET 2), 4, 'Good experience overall.'),
(uuid_generate_v4(), (SELECT id FROM transaction LIMIT 1 OFFSET 23), (SELECT id FROM account LIMIT 1 OFFSET 3), 5, 'Fantastic! Loved it.'),
(uuid_generate_v4(), (SELECT id FROM transaction LIMIT 1 OFFSET 24), (SELECT id FROM account LIMIT 1 OFFSET 4), 3, 'Decent, could improve.'),
(uuid_generate_v4(), (SELECT id FROM transaction LIMIT 1 OFFSET 25), (SELECT id FROM account LIMIT 1 OFFSET 5), 4, 'Satisfied with the service.'),
(uuid_generate_v4(), (SELECT id FROM transaction LIMIT 1 OFFSET 26), (SELECT id FROM account LIMIT 1 OFFSET 6), 5, 'Absolutely wonderful!'),
(uuid_generate_v4(), (SELECT id FROM transaction LIMIT 1 OFFSET 27), (SELECT id FROM account LIMIT 1 OFFSET 7), 2, 'Not happy with the service.'),
(uuid_generate_v4(), (SELECT id FROM transaction LIMIT 1 OFFSET 28), (SELECT id FROM account LIMIT 1 OFFSET 8), 1, 'Very bad experience.'),
(uuid_generate_v4(), (SELECT id FROM transaction LIMIT 1 OFFSET 29), (SELECT id FROM account LIMIT 1 OFFSET 9), 4, 'Quite good, met expectations.');

INSERT INTO account_voucher (id, account_id, voucher_id, quantity)
SELECT uuid_generate_v4(), account.id, voucher.id, floor(random() * 101) 
FROM account, voucher;

INSERT INTO event_voucher (id, voucher_id, event_id)
SELECT uuid_generate_v4(), voucher.id, event.id 
FROM event, voucher;

INSERT INTO transaction_voucher (id, transaction_id, voucher_id, quantity)
SELECT uuid_generate_v4(), transaction.id, voucher.id, floor(random() * 101) 
FROM transaction, voucher;

INSERT INTO transaction_point (id, transaction_id, point_id, fixed_amount)
SELECT uuid_generate_v4(), transaction.id, point.id, 10000 - point.fixed_amount 
FROM transaction, point;

INSERT INTO event_ticket (id, event_id, name, description, price, slots)
SELECT uuid_generate_v4(), event.id, 'Standard Ticket', 'Standard ticket for attending the event.', floor(random() * 300001), floor(random() * 1001)
FROM event;

INSERT INTO event_ticket_field (id, event_ticket_id, key)
SELECT uuid_generate_v4(), event_ticket.id, key
FROM event_ticket, (VALUES ('name'), ('phone'), ('email'), ('dob')) AS keys(key);

INSERT INTO transaction_ticket_field (id, transaction_id, event_ticket_field_id, value)
SELECT 
    uuid_generate_v4(), 
    transaction.id, 
    event_ticket_field.id, 
    CASE event_ticket_field.key
        WHEN 'name' THEN account.name
        WHEN 'phone' THEN account.phone
        WHEN 'email' THEN account.email
        WHEN 'dob' THEN account.dob::text
    END
FROM transaction
INNER JOIN account ON transaction.account_id = account.id
INNER JOIN event_ticket ON transaction.event_id = event_ticket.event_id
INNER JOIN event_ticket_field ON event_ticket.id = event_ticket_field.event_ticket_id
WHERE event_ticket_field.key IN ('name', 'phone', 'email', 'dob');

-- dql
SELECT * 
FROM account
INNER JOIN session ON session.account_id = account.id
INNER JOIN account_voucher ON account_voucher.account_id = account.id 
INNER JOIN voucher ON voucher.id = account_voucher.voucher_id
INNER JOIN event_voucher ON event_voucher.voucher_id = voucher.id
INNER JOIN point ON point.account_id = account.id
INNER JOIN transaction ON transaction.account_id = account.id
INNER JOIN feedback ON feedback.account_id = account.id
INNER JOIN transaction_voucher ON transaction_voucher.transaction_id = transaction.id
INNER JOIN transaction_point ON transaction_point.transaction_id = transaction.id 
INNER JOIN event ON event.id = transaction.event_id
INNER JOIN event_ticket ON event_ticket.event_id = event.id
INNER JOIN event_ticket_field ON event_ticket_field.event_ticket_id = event_ticket.id
INNER JOIN transaction_ticket_field ON transaction_ticket_field.transaction_id = transaction.id
WHERE account.id in (SELECT id FROM account LIMIT 1 OFFSET 0)
LIMIT 1 OFFSET 0;

select *
from event
order by SIMILARITY(name::text, 'art') desc
limit 1 
offset 0;

select voucher.* 
from event 
inner join event_voucher on event_voucher.event_id = event.id
inner join voucher on voucher.id = event_voucher.voucher_id
where lower(event.name) like '%tech%';

SELECT
DATE_TRUNC('hour', t.time) as x,
SUM(et.price) as y
FROM transaction t 
INNER JOIN event e ON e.id = t.event_id
INNER JOIN event_ticket et ON et.event_id = e.id
WHERE e.account_id = (SELECT id FROM account LIMIT 1 OFFSET 0)
GROUP BY x
ORDER BY x;

SELECT
DATE_TRUNC('week', t.time) as x,
SUM((select count(*) from transaction t2 where t2.id = t.id)) as y
FROM transaction t
INNER JOIN event e ON e.id = t.event_id
WHERE e.account_id = (SELECT id FROM account LIMIT 1 OFFSET 0)
GROUP BY x
ORDER BY x;