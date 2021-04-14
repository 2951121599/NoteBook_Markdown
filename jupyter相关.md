## jupyter相关

### jupyter 实现notebook中显示完整的行和列

```python
pd.set_option('max_columns', 1000)
pd.set_option('max_row', 300)
pd.set_option('display.float_format', lambda x: '%.5f' % x)
```

### 

