<?php


require_once "functions.php";




createTable('users',
    'id INT UNSIGNED AUTO_INCREMENT,
    username VARCHAR(30) NOT NULL,
    password VARCHAR(255) NOT NULL,
    INDEX(username(6)),
    PRIMARY KEY(id)
    '
);

createTable('profiles',
    'id INT UNSIGNED AUTO_INCREMENT,
    user_id INT UNSIGNED UNIQUE,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    phone VARCHAR(255) NOT NULL,
    address VARCHAR(255) NOT NULL,
    place VARCHAR(255) NOT NULL,
    discount INT,
    PRIMARY KEY(id),
    FOREIGN KEY(user_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE NO ACTION
    '
);

createTable('messages',
    'id INT UNSIGNED AUTO_INCREMENT,
    auth_id INT UNSIGNED NOT NULL,
    recip_id INT UNSIGNED NOT NULL,
    time INT UNSIGNED NOT NULL,
    message VARCHAR(4096) NOT NULL,
    PRIMARY KEY(id),
    FOREIGN KEY(auth_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE NO ACTION,
    FOREIGN KEY(recip_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE NO ACTION
    '
);

createTable('dmessages',
    'id INT UNSIGNED AUTO_INCREMENT,
    auth_id INT UNSIGNED NOT NULL,
    recip_id INT UNSIGNED NOT NULL,
    time INT UNSIGNED NOT NULL,
    message VARCHAR(4096) NOT NULL,
    deleteTime date,
    PRIMARY KEY(id),
    FOREIGN KEY(auth_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE NO ACTION,
    FOREIGN KEY(recip_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE NO ACTION
    '
);

createTable('roles', 
    'id INT UNSIGNED AUTO_INCREMENT,
    role_name VARCHAR(200) NOT NULL,
    PRIMARY KEY(id)
    '
);

createTable('permissions',
    'id INT UNSIGNED AUTO_INCREMENT,
    perm_desc VARCHAR(200) NOT NULL,
    PRIMARY KEY(id)
    '
);

createTable('role_permissions',
    'id INT UNSIGNED AUTO_INCREMENT,
    role_id INT UNSIGNED NOT NULL,
    perm_id INT UNSIGNED NOT NULL,
    PRIMARY KEY(id),
    FOREIGN KEY(role_id) REFERENCES roles(id) ON UPDATE CASCADE ON DELETE NO ACTION,
    FOREIGN KEY(perm_id) REFERENCES permissions(id) ON UPDATE CASCADE ON DELETE NO ACTION
    '
);

createTable('user_roles',
    'id INT UNSIGNED AUTO_INCREMENT,
    user_id INT UNSIGNED NOT NULL,
    role_id INT UNSIGNED NOT NULL,
    PRIMARY KEY(id),
    FOREIGN KEY(user_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE NO ACTION,
    FOREIGN KEY(role_id) REFERENCES roles(id) ON UPDATE CASCADE ON DELETE NO ACTION
    '
);

createTable('prod_types',
    'id INT UNSIGNED AUTO_INCREMENT,
    name VARCHAR(45) NOT NULL,
    PRIMARY KEY(id)
    '
);

createTable('products',
    'id INT UNSIGNED AUTO_INCREMENT,
    name VARCHAR(45) NOT NULL,
    stock INT DEFAULT 0,
    sold INT DEFAULT 0,
    price INT DEFAULT 0,
    pdesc VARCHAR(200) NOT NULL,
    type_id INT NOT NULL,
    PRIMARY KEY(id),
    FOREIGN KEY(type_id) REFERENCES prod_types(id) ON UPDATE CASCADE ON DELETE NO ACTION
    '
);

createTable('cart',
    'id INT UNSIGNED AUTO_INCREMENT,
    buyer_id INT UNSIGNED NOT NULL,
    product_id INT UNSIGNED NOT NULL,
    amount INT UNSIGNED NOT NULL,
    sum_price INT UNSIGNED NOT NULL,
    PRIMARY KEY(id),
    FOREIGN KEY(buyer_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE NO ACTION,
    FOREIGN KEY(product_id) REFERENCES products(id) ON UPDATE CASCADE ON DELETE NO ACTION
    '
);

createTable('orders',
    'id INT UNSIGNED AUTO_INCREMENT,
    buyer_id INT UNSIGNED NOT NULL,
    product_id INT UNSIGNED NOT NULL,
    amount INT UNSIGNED NOT NULL,
    sum_price INT UNSIGNED NOT NULL,
    vreme TEXT,
    PRIMARY KEY(id),
    FOREIGN KEY(buyer_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE NO ACTION,
    FOREIGN KEY(product_id) REFERENCES products(id) ON UPDATE CASCADE ON DELETE NO ACTION
    '
);

createTable('changes',
    'id INT UNSIGNED AUTO_INCREMENT,
    time DATETIME,
    product_id INT UNSIGNED NOT NULL,
    trgovina VARCHAR(300),
    PRIMARY KEY(id),
    FOREIGN KEY(product_id) REFERENCES products(id) ON UPDATE CASCADE ON DELETE NO ACTION
    '
);

createTable('purchases',
    'id INT UNSIGNED AUTO_INCREMENT,
    product_id INT UNSIGNED NOT NULL,
    time DATETIME,
    amount INT UNSIGNED NOT NULL,
    price_piece INT UNSIGNED NOT NULL,
    PRIMARY KEY(id),
    FOREIGN KEY(product_id) REFERENCES products(id) ON UPDATE CASCADE ON DELETE NO ACTION
    '
);

createTable('weekly',
    'id INT UNSIGNED AUTO_INCREMENT,
    product_id INT UNSIGNED NOT NULL,
    sold INT UNSIGNED NOT NULL,
    PRIMARY KEY(id),
    FOREIGN KEY(product_id) REFERENCES products(id) ON UPDATE CASCADE ON DELETE NO ACTION
    '
);




