use board2;

create table author(
    id int auto_increment,
    name varchar(255), 
    email varchar(255) not null,
    created_time datetime default current_timestamp,
    primary key(id)
);

create table post (
    id int auto_increment,
    title varchar(255) not null,
    contents varchar(3000),
    primary key(id)
);

create table author_address(
    id int auto_increment,
    city varchar(255),
    street varchar(255),
    author_id int not null,
    primary key(id),
    unique(author_id),
    foreign key(author_id) references author(id) on delete cascade
);

create table author_post(
    id int auto_increment,
    author_id int not null,
    post_id int not null,
    primary key(id),
    foreign key(author_id) references author(id),
    foreign key(post_id) references post(id)
);