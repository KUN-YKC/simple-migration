create table if not exists table2 (
    user_id varchar(30) not null primary key comment "用户id",
    user_name varchar(40) not null comment "用户名",
    create_time int(11) default 0 comment "创建时间"
)
