

@outputSchema("num:chararray")
def get_ip_snipped(data):
    if data.count('.') < 3:
        return ''
    else:
        return '.'.join(data.split('.')[:3])

# print get_ip_snipped("123.321.123.12341")
