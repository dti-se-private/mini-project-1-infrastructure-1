-- extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ddl
DROP TABLE IF EXISTS account CASCADE;
CREATE TABLE account (
    id UUID PRIMARY KEY,
    name TEXT,
    email TEXT UNIQUE,
    password TEXT,
    phone TEXT,
    dob TIMESTAMPTZ,
    referral_code TEXT UNIQUE
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
    time TIMESTAMPTZ
);

DROP TABLE IF EXISTS transaction CASCADE;
CREATE TABLE transaction (
    id UUID PRIMARY KEY,
    event_id UUID REFERENCES event(id) ON DELETE CASCADE ON UPDATE CASCADE,
    account_id UUID REFERENCES account(id) ON DELETE CASCADE ON UPDATE CASCADE,
    timestamp TIMESTAMPTZ
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
    key TEXT
);

DROP TABLE IF EXISTS transaction_ticket_field CASCADE;
CREATE TABLE transaction_ticket_field (
    id UUID PRIMARY KEY,
    transaction_id UUID REFERENCES transaction(id) ON DELETE CASCADE ON UPDATE CASCADE,
    event_ticket_field_id UUID REFERENCES event_ticket_field(id) ON DELETE CASCADE ON UPDATE CASCADE,
    value TEXT
);

-- dml
INSERT INTO account (id, name, email, password, phone, dob, referral_code) VALUES
(uuid_generate_v4(), 'Andy', 'andy@mail.com', 'password', '08123456789', '1990-01-01', 'H7D3F9O1U8'),
(uuid_generate_v4(), 'Beth', 'beth@mail.com', 'password', '08123456780', '1990-02-01', 'G1X4K2J8L'),
(uuid_generate_v4(), 'Charles', 'charles@mail.com', 'password', '08123456781', '1990-03-01', 'Q8Y6M4P1N'),
(uuid_generate_v4(), 'Diana', 'diana@mail.com', 'password', '08123456782', '1990-04-01', 'T5R3L1W7H'),
(uuid_generate_v4(), 'Edward', 'edward@mail.com', 'password', '08123456783', '1990-05-01', 'Z2V8C6J9P'),
(uuid_generate_v4(), 'Fiona', 'fiona@mail.com', 'password', '08123456784', '1990-06-01', 'B9K7H5T3M'),
(uuid_generate_v4(), 'George', 'george@mail.com', 'password', '08123456785', '1990-07-01', 'D4W1N8R6L'),
(uuid_generate_v4(), 'Hannah', 'hannah@mail.com', 'password', '08123456786', '1990-08-01', 'J2P9X3C7F'),
(uuid_generate_v4(), 'Isaac', 'isaac@mail.com', 'password', '08123456787', '1990-09-01', 'L5T6Z1M3R'),
(uuid_generate_v4(), 'Jasmine', 'jasmine@mail.com', 'password', '08123456788', '1990-10-01', 'N4V8P2K7Y'),
(uuid_generate_v4(), 'Kevin', 'kevin@mail.com', 'password', '08123456789', '1990-11-01', 'F1C7H9M5P'),
(uuid_generate_v4(), 'Lila', 'lila@mail.com', 'password', '08123456790', '1990-12-01', 'H3J2K8L4W'),
(uuid_generate_v4(), 'Mark', 'mark@mail.com', 'password', '08123456791', '1990-01-02', 'K4M5L8P6N'),
(uuid_generate_v4(), 'Nina', 'nina@mail.com', 'password', '08123456792', '1990-02-02', 'R7P1V9X3L'),
(uuid_generate_v4(), 'Owen', 'owen@mail.com', 'password', '08123456793', '1990-03-02', 'Y5T2H6P4J'),
(uuid_generate_v4(), 'Paula', 'paula@mail.com', 'password', '08123456794', '1990-04-02', 'M3X7K9W2L'),
(uuid_generate_v4(), 'Quinn', 'quinn@mail.com', 'password', '08123456795', '1990-05-02', 'P4R1D8M6Z'),
(uuid_generate_v4(), 'Rita', 'rita@mail.com', 'password', '08123456796', '1990-06-02', 'K7W3T2L9H'),
(uuid_generate_v4(), 'Sam', 'sam@mail.com', 'password', '08123456797', '1990-07-02', 'M8Y6P5J3X'),
(uuid_generate_v4(), 'Tina', 'tina@mail.com', 'password', '08123456798', '1990-08-02', 'N1V3R9C4P'),
(uuid_generate_v4(), 'Ursula', 'ursula@mail.com', 'password', '08123456799', '1990-09-02', 'L5T8H7P3K'),
(uuid_generate_v4(), 'Victor', 'victor@mail.com', 'password', '08123456800', '1990-10-02', 'R6M1P9W4Y'),
(uuid_generate_v4(), 'Wendy', 'wendy@mail.com', 'password', '08123456801', '1990-11-02', 'X3P7K2H6N'),
(uuid_generate_v4(), 'Xander', 'xander@mail.com', 'password', '08123456802', '1990-12-02', 'Z2T9P5W1H'),
(uuid_generate_v4(), 'Yasmine', 'yasmine@mail.com', 'password', '08123456803', '1991-01-01', 'L4J8V3T7M'),
(uuid_generate_v4(), 'Zack', 'zack@mail.com', 'password', '08123456804', '1991-02-01', 'C7R2P8K5H'),
(uuid_generate_v4(), 'Alicia', 'alicia@mail.com', 'password', '08123456805', '1991-03-01', 'M1P4T6N3J'),
(uuid_generate_v4(), 'Brian', 'brian@mail.com', 'password', '08123456806', '1991-04-01', 'W9H5T3P2L'),
(uuid_generate_v4(), 'Cindy', 'cindy@mail.com', 'password', '08123456807', '1991-05-01', 'H3P7L9W6M'),
(uuid_generate_v4(), 'David', 'david@mail.com', 'password', '08123456808', '1991-06-01', 'N8T5K2L4P');

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

INSERT INTO event (id, account_id, name, description, location, category, time) VALUES
(uuid_generate_v4(), (SELECT id FROM account LIMIT 1 OFFSET 0), 'Music Festival', 'An outdoor music festival with various artists.', 'https://goo.gl/maps/abc123', 'Entertainment', '2024-12-01 18:00:00'),
(uuid_generate_v4(), (SELECT id FROM account LIMIT 1 OFFSET 1), 'Art Exhibition', 'An exhibition showcasing modern art.', 'https://goo.gl/maps/def456', 'Art', '2025-01-15 10:00:00'),
(uuid_generate_v4(), (SELECT id FROM account LIMIT 1 OFFSET 2), 'Tech Conference', 'Annual conference for tech enthusiasts.', 'https://goo.gl/maps/ghi789', 'Conference', '2025-02-20 09:00:00'),
(uuid_generate_v4(), (SELECT id FROM account LIMIT 1 OFFSET 3), 'Cooking Workshop', 'Hands-on cooking workshop with a celebrity chef.', 'https://goo.gl/maps/jkl012', 'Workshop', '2025-03-05 14:00:00'),
(uuid_generate_v4(), (SELECT id FROM account LIMIT 1 OFFSET 4), 'Charity Run', 'A 5K run to raise funds for charity.', 'https://goo.gl/maps/mno345', 'Sports', '2025-04-10 07:00:00'),
(uuid_generate_v4(), (SELECT id FROM account LIMIT 1 OFFSET 5), 'Book Launch', 'Launch event for a new book by a bestselling author.', 'https://goo.gl/maps/pqr678', 'Literature', '2025-05-01 18:30:00'),
(uuid_generate_v4(), (SELECT id FROM account LIMIT 1 OFFSET 6), 'Yoga Retreat', 'A weekend retreat focusing on yoga and wellness.', 'https://goo.gl/maps/stu901', 'Health', '2025-06-15 08:00:00'),
(uuid_generate_v4(), (SELECT id FROM account LIMIT 1 OFFSET 7), 'Film Screening', 'Special screening of an indie film.', 'https://goo.gl/maps/vwx234', 'Entertainment', '2025-07-20 20:00:00'),
(uuid_generate_v4(), (SELECT id FROM account LIMIT 1 OFFSET 8), 'Science Fair', 'Annual science fair showcasing student projects.', 'https://goo.gl/maps/yza567', 'Education', '2025-08-10 09:00:00'),
(uuid_generate_v4(), (SELECT id FROM account LIMIT 1 OFFSET 9), 'Gardening Workshop', 'Learn about urban gardening techniques.', 'https://goo.gl/maps/bcd890', 'Workshop', '2025-09-05 13:00:00'),
(uuid_generate_v4(), (SELECT id FROM account LIMIT 1 OFFSET 10), 'Dance Performance', 'A contemporary dance performance.', 'https://goo.gl/maps/efg123', 'Entertainment', '2025-10-01 19:00:00'),
(uuid_generate_v4(), (SELECT id FROM account LIMIT 1 OFFSET 11), 'Business Meetup', 'Networking event for business professionals.', 'https://goo.gl/maps/hij456', 'Networking', '2025-11-15 17:00:00'),
(uuid_generate_v4(), (SELECT id FROM account LIMIT 1 OFFSET 12), 'Photography Exhibition', 'Exhibition featuring travel photography.', 'https://goo.gl/maps/klm789', 'Art', '2025-12-20 11:00:00'),
(uuid_generate_v4(), (SELECT id FROM account LIMIT 1 OFFSET 13), 'Fitness Bootcamp', 'Intense fitness bootcamp session.', 'https://goo.gl/maps/nop012', 'Health', '2026-01-05 06:00:00'),
(uuid_generate_v4(), (SELECT id FROM account LIMIT 1 OFFSET 14), 'Cooking Class', 'Learn to cook traditional dishes.', 'https://goo.gl/maps/qrs345', 'Workshop', '2026-02-12 14:00:00'),
(uuid_generate_v4(), (SELECT id FROM account LIMIT 1 OFFSET 15), 'Career Fair', 'Career fair for recent graduates.', 'https://goo.gl/maps/tuv678', 'Education', '2026-03-10 10:00:00'),
(uuid_generate_v4(), (SELECT id FROM account LIMIT 1 OFFSET 16), 'Music Concert', 'Live concert by a popular band.', 'https://goo.gl/maps/wxy901', 'Entertainment', '2026-04-25 20:00:00'),
(uuid_generate_v4(), (SELECT id FROM account LIMIT 1 OFFSET 17), 'Theater Play', 'Local theater group performing a classic play.', 'https://goo.gl/maps/zab234', 'Entertainment', '2026-05-18 19:30:00'),
(uuid_generate_v4(), (SELECT id FROM account LIMIT 1 OFFSET 18), 'Workshop on Coding', 'Introductory workshop on programming.', 'https://goo.gl/maps/cde567', 'Education', '2026-06-07 09:00:00'),
(uuid_generate_v4(), (SELECT id FROM account LIMIT 1 OFFSET 19), 'Environmental Seminar', 'Seminar on climate change and sustainability.', 'https://goo.gl/maps/fgh890', 'Education', '2026-07-22 14:00:00'),
(uuid_generate_v4(), (SELECT id FROM account LIMIT 1 OFFSET 20), 'Food Festival', 'A festival celebrating local cuisine.', 'https://goo.gl/maps/ijk123', 'Entertainment', '2026-08-30 12:00:00'),
(uuid_generate_v4(), (SELECT id FROM account LIMIT 1 OFFSET 21), 'Mindfulness Retreat', 'A weekend retreat focusing on mindfulness and meditation.', 'https://goo.gl/maps/lmn456', 'Health', '2026-09-18 08:00:00'),
(uuid_generate_v4(), (SELECT id FROM account LIMIT 1 OFFSET 22), 'Charity Gala', 'A gala event to raise funds for charity.', 'https://goo.gl/maps/opq789', 'Networking', '2026-10-10 18:00:00'),
(uuid_generate_v4(), (SELECT id FROM account LIMIT 1 OFFSET 23), 'Cultural Festival', 'A festival celebrating diverse cultures.', 'https://goo.gl/maps/rst012', 'Entertainment', '2026-11-05 10:00:00'),
(uuid_generate_v4(), (SELECT id FROM account LIMIT 1 OFFSET 24), 'Public Speaking Workshop', 'Improve your public speaking skills.', 'https://goo.gl/maps/uvw345', 'Workshop', '2026-12-01 09:00:00'),
(uuid_generate_v4(), (SELECT id FROM account LIMIT 1 OFFSET 25), 'Product Launch', 'Launch event for a new tech product.', 'https://goo.gl/maps/xyz678', 'Conference', '2026-12-15 15:00:00'),
(uuid_generate_v4(), (SELECT id FROM account LIMIT 1 OFFSET 26), 'Art Fair', 'A fair showcasing local artists and their work.', 'https://goo.gl/maps/abc901', 'Art', '2027-01-20 10:00:00'),
(uuid_generate_v4(), (SELECT id FROM account LIMIT 1 OFFSET 27), 'Writing Workshop', 'Workshop on creative writing techniques.', 'https://goo.gl/maps/def234', 'Workshop', '2027-02-05 14:00:00'),
(uuid_generate_v4(), (SELECT id FROM account LIMIT 1 OFFSET 28), 'Health Fair', 'A fair promoting health and wellness.', 'https://goo.gl/maps/ghi567', 'Health', '2027-03-10 08:00:00'),
(uuid_generate_v4(), (SELECT id FROM account LIMIT 1 OFFSET 29), 'Innovation Summit', 'Summit on innovation and entrepreneurship.', 'https://goo.gl/maps/jkl890', 'Conference', '2027-04-25 09:00:00');

INSERT INTO transaction (id, event_id, account_id, timestamp) VALUES
(uuid_generate_v4(), (SELECT id FROM event LIMIT 1 OFFSET 0), (SELECT id FROM account LIMIT 1 OFFSET 0), now() - interval '1 day'),
(uuid_generate_v4(), (SELECT id FROM event LIMIT 1 OFFSET 1), (SELECT id FROM account LIMIT 1 OFFSET 1), now() - interval '2 days'),
(uuid_generate_v4(), (SELECT id FROM event LIMIT 1 OFFSET 2), (SELECT id FROM account LIMIT 1 OFFSET 2), now() - interval '3 days'),
(uuid_generate_v4(), (SELECT id FROM event LIMIT 1 OFFSET 3), (SELECT id FROM account LIMIT 1 OFFSET 3), now() - interval '4 days'),
(uuid_generate_v4(), (SELECT id FROM event LIMIT 1 OFFSET 4), (SELECT id FROM account LIMIT 1 OFFSET 4), now() - interval '5 days'),
(uuid_generate_v4(), (SELECT id FROM event LIMIT 1 OFFSET 5), (SELECT id FROM account LIMIT 1 OFFSET 5), now() - interval '6 days'),
(uuid_generate_v4(), (SELECT id FROM event LIMIT 1 OFFSET 6), (SELECT id FROM account LIMIT 1 OFFSET 6), now() - interval '7 days'),
(uuid_generate_v4(), (SELECT id FROM event LIMIT 1 OFFSET 7), (SELECT id FROM account LIMIT 1 OFFSET 7), now() - interval '8 days'),
(uuid_generate_v4(), (SELECT id FROM event LIMIT 1 OFFSET 8), (SELECT id FROM account LIMIT 1 OFFSET 8), now() - interval '9 days'),
(uuid_generate_v4(), (SELECT id FROM event LIMIT 1 OFFSET 9), (SELECT id FROM account LIMIT 1 OFFSET 9), now() - interval '10 days'),
(uuid_generate_v4(), (SELECT id FROM event LIMIT 1 OFFSET 0), (SELECT id FROM account LIMIT 1 OFFSET 10), now() - interval '11 days'),
(uuid_generate_v4(), (SELECT id FROM event LIMIT 1 OFFSET 1), (SELECT id FROM account LIMIT 1 OFFSET 11), now() - interval '12 days'),
(uuid_generate_v4(), (SELECT id FROM event LIMIT 1 OFFSET 2), (SELECT id FROM account LIMIT 1 OFFSET 12), now() - interval '13 days'),
(uuid_generate_v4(), (SELECT id FROM event LIMIT 1 OFFSET 3), (SELECT id FROM account LIMIT 1 OFFSET 13), now() - interval '14 days'),
(uuid_generate_v4(), (SELECT id FROM event LIMIT 1 OFFSET 4), (SELECT id FROM account LIMIT 1 OFFSET 14), now() - interval '15 days'),
(uuid_generate_v4(), (SELECT id FROM event LIMIT 1 OFFSET 5), (SELECT id FROM account LIMIT 1 OFFSET 15), now() - interval '16 days'),
(uuid_generate_v4(), (SELECT id FROM event LIMIT 1 OFFSET 6), (SELECT id FROM account LIMIT 1 OFFSET 16), now() - interval '17 days'),
(uuid_generate_v4(), (SELECT id FROM event LIMIT 1 OFFSET 7), (SELECT id FROM account LIMIT 1 OFFSET 17), now() - interval '18 days'),
(uuid_generate_v4(), (SELECT id FROM event LIMIT 1 OFFSET 8), (SELECT id FROM account LIMIT 1 OFFSET 18), now() - interval '19 days'),
(uuid_generate_v4(), (SELECT id FROM event LIMIT 1 OFFSET 9), (SELECT id FROM account LIMIT 1 OFFSET 19), now() - interval '20 days'),
(uuid_generate_v4(), (SELECT id FROM event LIMIT 1 OFFSET 0), (SELECT id FROM account LIMIT 1 OFFSET 20), now() - interval '21 days'),
(uuid_generate_v4(), (SELECT id FROM event LIMIT 1 OFFSET 1), (SELECT id FROM account LIMIT 1 OFFSET 21), now() - interval '22 days'),
(uuid_generate_v4(), (SELECT id FROM event LIMIT 1 OFFSET 2), (SELECT id FROM account LIMIT 1 OFFSET 22), now() - interval '23 days'),
(uuid_generate_v4(), (SELECT id FROM event LIMIT 1 OFFSET 3), (SELECT id FROM account LIMIT 1 OFFSET 23), now() - interval '24 days'),
(uuid_generate_v4(), (SELECT id FROM event LIMIT 1 OFFSET 4), (SELECT id FROM account LIMIT 1 OFFSET 24), now() - interval '25 days'),
(uuid_generate_v4(), (SELECT id FROM event LIMIT 1 OFFSET 5), (SELECT id FROM account LIMIT 1 OFFSET 25), now() - interval '26 days'),
(uuid_generate_v4(), (SELECT id FROM event LIMIT 1 OFFSET 6), (SELECT id FROM account LIMIT 1 OFFSET 26), now() - interval '27 days'),
(uuid_generate_v4(), (SELECT id FROM event LIMIT 1 OFFSET 7), (SELECT id FROM account LIMIT 1 OFFSET 27), now() - interval '28 days'),
(uuid_generate_v4(), (SELECT id FROM event LIMIT 1 OFFSET 8), (SELECT id FROM account LIMIT 1 OFFSET 28), now() - interval '29 days'),
(uuid_generate_v4(), (SELECT id FROM event LIMIT 1 OFFSET 9), (SELECT id FROM account LIMIT 1 OFFSET 29), now() - interval '30 days');

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
SELECT uuid_generate_v4(), account.id, voucher.id, floor(random() * 11) 
FROM account, voucher;

INSERT INTO event_voucher (id, voucher_id, event_id)
SELECT uuid_generate_v4(), voucher.id, event.id 
FROM voucher, event;

INSERT INTO transaction_voucher (id, transaction_id, voucher_id, quantity)
SELECT uuid_generate_v4(), transaction.id, voucher.id, floor(random() * 11) 
FROM transaction, voucher;

INSERT INTO transaction_point (id, transaction_id, point_id, fixed_amount)
SELECT uuid_generate_v4(), transaction.id, point.id, 10000 - point.fixed_amount 
FROM transaction, point;

INSERT INTO event_ticket (id, event_id, name, price, slots)
SELECT uuid_generate_v4(), event.id, 'reguler', floor(random() * 300001), floor(random() * (20) + 1) * 50 
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



