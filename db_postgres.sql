CREATE TABLE table_seller(
    id SERIAL NOT NULL PRIMARY KEY,
    first_name TEXT NOT NULL CHECK (first_name <> ''),
    last_name TEXT NOT NULL CHECK (last_name <> ''),
    patronymic TEXT NULL CHECK (patronymic <> ''),
    post_id INT NOT NULL,
    date_admission DATE NOT NULL,
    gender TEXT CHECK (gender == 'M' or gender == 'F'),
    salary NUMERIC NOT NULL CHECK (salary >= 0.0)
);


CREATE TABLE table_posts(
    id SERIAL NOT NULL PRIMARY KEY,
    post TEXT NOT NULL CHECK (post <> ''),
    FOREIGN KEY (id) REFERENCES table_seller(post_id)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
);
CREATE TABLE table_clients(
    id SERIAL NOT NULL PRIMARY KEY,
    first_name TEXT NOT NULL CHECK (first_name <> ''),
    last_name TEXT NOT NULL CHECK (last_name <> ''),
    patronymic TEXT NULL CHECK (patronymic <> ''),
    email_id INT NOT NULL,
    telephone_id INT NOT NULL,
    gender TEXT CHECK (gender == 'M' or gender == 'F'),
    order_history_id INT NOT NULL,
    discount_id INT NOT NULL,
    subscription BOOLEAN DEFAULT FALSE
);

CREATE TABLE table_order_history(
    id SERIAL NOT NULL PRIMARY KEY,
    product_id INT NOT NULL REFERENCES table_products(id),
    FOREIGN KEY (id) REFERENCES table_clients(order_history_id)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
);
CREATE TABLE table_emails(
    id SERIAL NOT NULL PRIMARY KEY,
    email TEXT NOT NULL CHECK(email LIKE '%@%'),
    FOREIGN KEY (id) REFERENCES table_clients(email_id)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
);
CREATE TABLE table_telephones(
    id SERIAL NOT NULL PRIMARY KEY,
    telephone TEXT NOT NULL,
    FOREIGN KEY (id) REFERENCES table_clients(telephone_id)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
);
CREATE TABLE table_discounts(
    id SERIAL NOT NULL PRIMARY KEY,
    discount INT NOT NULL CHECK(discount >= 0),
    FOREIGN KEY (id) REFERENCES table_clients(discount_id)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
);
CREATE TABLE table_products (
    id SERIAL NOT NULL PRIMARY KEY,
    name TEXT NOT NULL CHECK (name <> ''),
    product_type_id INT NOT NULL,
    product_quantity INT NOT NULL CHECK (product_quantity >= 0),
    cost_price NUMERIC NOT NULL CHECK (cost_price > 0.0),
    manufacturer_id INT NOT NULL,
    sale_price NUMERIC NOT NULL CHECK (sale_price > 0.0),
    FOREIGN KEY (id) REFERENCES table_sales(product_name_id)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION

);
CREATE TABLE table_product_type(
    id SERIAL NOT NULL PRIMARY KEY,
    type TEXT NOT NULL CHECK (type <> ''),
    FOREIGN KEY (id) REFERENCES table_products(product_type_id)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
);

CREATE TABLE table_manufacturer_id(
    id SERIAL NOT NULL PRIMARY KEY,
    manufacturer TEXT NOT NULL CHECK (manufacturer <> ''),
    FOREIGN KEY (id) REFERENCES table_products(manufacturer_id)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
);
CREATE TABLE table_sales(
    id SERIAL NOT NULL PRIMARY KEY,
    product_name_id INT NOT NULL REFERENCES table_products(id),
    sale_price NUMERIC NOT NULL, CHECK (sale_price >= 0.0),
    quantity_sold INT NOT NULL CHECK (quantity_sold > 0),
    date_sale DATE NOT NULL,
    info_seller_id INT NOT NULL REFERENCES table_seller(id),
    cline_registered BOOLEAN DEFAULT FALSE,
    info_buyer_id INT NOT NULL REFERENCES table_clients(id)
);
