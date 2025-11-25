CREATE TYPE sex AS ENUM ('M', 'F');

CREATE TABLE table_positions
(
    id       SERIAL NOT NULL PRIMARY KEY,
    position TEXT   NOT NULL CHECK (position <> '')

);

CREATE TABLE table_emails
(
    id    SERIAL NOT NULL PRIMARY KEY,
    email TEXT   NOT NULL CHECK (email LIKE '%@%')

);

CREATE TABLE table_telephones
(
    id        SERIAL NOT NULL PRIMARY KEY,
    telephone TEXT   NOT NULL

);

CREATE TABLE table_discounts
(
    id            SERIAL NOT NULL PRIMARY KEY,
    discount_name TEXT   NOT NULL CHECK ( discount_name <> 0 ),
    discount      INT    NOT NULL CHECK (discount >= 0)

);

CREATE TABLE table_product_types
(
    id   SERIAL NOT NULL PRIMARY KEY,
    type TEXT   NOT NULL CHECK (type <> '')

);

CREATE TABLE table_manufacturers
(
    id           SERIAL NOT NULL PRIMARY KEY,
    manufacturer TEXT   NOT NULL CHECK (manufacturer <> '')

);

CREATE TABLE table_sellers
(
    id             SERIAL  NOT NULL PRIMARY KEY,
    first_name     TEXT    NOT NULL CHECK (first_name <> ''),
    last_name      TEXT    NOT NULL CHECK (last_name <> ''),
    patronymic     TEXT    NULL CHECK (patronymic <> ''),
    positions_id   INT     NOT NULL,
    date_admission DATE    NOT NULL,
    sex            sex,
    salary         NUMERIC NOT NULL CHECK (salary >= 0.0),
    FOREIGN KEY (positions_id) REFERENCES table_positions (id)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION

);
CREATE TABLE table_order_formats
(
    id     SERIAL NOT NULL PRIMARY KEY,
    format TEXT   NOT NULL CHECK (format <> '')
);
CREATE TABLE table_list_products
(
    id         SERIAL  NOT NULL PRIMARY KEY,
    order_id   INT     NOT NULL,
    product_id INT     NOT NULL,
    quantity   NUMERIC NOT NULL CHECK (quantity >= 0.0),
    FOREIGN KEY (order_id) REFERENCES table_orders (id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (product_id) REFERENCES table_products (id)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
);

CREATE TABLE table_price_change_history
(
    id    SERIAL  NOT NULL PRIMARY KEY,
    date  DATE    NOT NULL,
    price NUMERIC NOT NULL CHECK (price >= 0.0)
);

CREATE TABLE table_matrics
(
    id        SERIAL NOT NULL PRIMARY KEY,
    unit_type TEXT   NOT NULL CHECK (unit_type <> '')
);

CREATE TABLE table_price_per_unit_types
(
    id             SERIAL  NOT NULL PRIMARY KEY,
    price_per_unit NUMERIC NOT NULL CHECK (price_per_unit >= 0.0),
    unit_type_id   INT     NOT NULL,
    FOREIGN KEY (unit_type_id) REFERENCES table_matrics (id)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
);

CREATE TABLE table_products
(
    id                 SERIAL  NOT NULL PRIMARY KEY,
    product_name       TEXT    NOT NULL CHECK (product_name <> ''),
    product_type_id    INT     NOT NULL,
    price_id           INT     NOT NULL,
    price_per_unit_id  INT     NOT NULL,
    expiration_date    DATE    NULL,
    manufacturing_date DATE    NOT NULL,
    product_quantity   INT     NOT NULL CHECK ( product_quantity >= 0),
    primecost          NUMERIC NOT NULL CHECK (primecost >= 0.0),
    manufacturer_id    INT     NOT NULL,
    FOREIGN KEY (manufacturer_id) REFERENCES table_manufacturers (id)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION,
    FOREIGN KEY (price_id) REFERENCES table_price_change_history (id)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION,
    FOREIGN KEY (price_per_unit_id) REFERENCES table_price_per_unit_types (id)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION,
    FOREIGN KEY (product_type_id) REFERENCES table_product_types (id)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
);
CREATE TABLE table_clients
(
    id           SERIAL NOT NULL PRIMARY KEY,
    first_name   TEXT   NOT NULL CHECK (first_name <> ''),
    last_name    TEXT   NOT NULL CHECK (last_name <> ''),
    patronymic   TEXT   NULL CHECK (patronymic <> ''),
    email_id     INT    NOT NULL,
    telephone_id INT    NOT NULL,
    sex          sex,
    order_id     INT    NOT NULL,
    discount_id  INT    NOT NULL,
    subscription BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (telephone_id) REFERENCES table_telephones (id)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION,
    FOREIGN KEY (email_id) REFERENCES table_emails (id)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION,
    FOREIGN KEY (order_id) REFERENCES table_emails (id)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION,
    FOREIGN KEY (discount_id) REFERENCES table_discounts (id)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
);


CREATE TABLE table_orders
(
    id               SERIAL NOT NULL PRIMARY KEY,
    order_date       DATE   NOT NULL,
    payment_status   BOOLEAN DEFAULT FALSE,
    order_format_id  INT    NOT NULL,
    list_products_id INT    NOT NULL,
    is_registered    BOOLEAN DEFAULT FALSE,
    client_id        INT    NULL,
    FOREIGN KEY (client_id) REFERENCES table_clients (id)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION,
    FOREIGN KEY (order_format_id) REFERENCES table_order_formats (id)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION,
    FOREIGN KEY (list_products_id) REFERENCES table_list_products (id)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION

);

CREATE TABLE table_sales
(
    id        SERIAL NOT NULL PRIMARY KEY,
    order_id  INT    NOT NULL,
    date_sale DATE   NOT NULL,
    seller_id INT    NOT NULL,
    FOREIGN KEY (order_id) REFERENCES table_orders (id)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION,
    FOREIGN KEY (seller_id) REFERENCES table_sellers (id)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
);