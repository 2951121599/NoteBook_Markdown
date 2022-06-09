## sql

### 更新表中的部分值

```sql
update ion_info set is_delete='1' where feature in('X288','X296','X317')
```

### 添加字段

```sql
ALTER TABLE `zjap`.`zp_integration_data` 
ADD COLUMN `check_result` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '1:pass 2:no pass' AFTER `order_index`;
```

