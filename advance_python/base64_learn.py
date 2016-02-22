#!/usr/bin/env python
# -*- coding: utf-8 -*-
# @Author: Jinyong.Yang
# @Date:   2015-11-25 18:04:07
# @Last Modified by:   Jinyong.Yang
# @Last Modified time: 2015-11-26 18:06:32



import base64, binascii



ENCODE_TABLE = list("IWfsh_zKAinp6H2TZVCdOPL1D3k5etlqQGBMgXjFJwauvUcNo-bmY0ESr7Rxy489")

AUDIENCE_STR_ENCODE_TABLE = list(" 1234567890=,-E.")

DECODE_TABLE = [None] * 256
AUDIENCE_STR_DECODE_TABLE = [None] * 256

MD5_PADDING = "#@ipinyou_md5%$"

UTF_8 = "UTF-8"

platform = """Adx    Z1dx
Tanx    PKK-B_
Sina    OSF-eP
Ifeng    C15JquB
Vam    PFKo
Baidu    ZFKvt6k
Youku    L19rlyk
YkSem    L1NLt5R
Miaozhen    d1FgqyNNGqf"""



s = "ZFKvt6k"

def decrypt(charIndex, crptyIndex):
	r = crptyIndex - charIndex % 64;
	if (r < 0) :
		r += 64
	return r


def decode(s):
	if not s:
		return ""
	chars = list(s)
	fullGroups = len(chars) // 4
	remainChars = len(chars) % 4
	ret = [None] * ((len(chars ) - 1) * 3 / //4 + 1)
	i=c0=c1=b0=b1=b2 =0
	for i in range(fullGroups):
		c0 = i * 4
		c1 = i * 4 + 1
		c2 = i * 4 + 2
		b0 = i * 4 + 3
		b1 = decrypt(c0, DECODE_TABLE[chars[c0]])
		b2 = decrypt(c1, DECODE_TABLE[chars[c1]])
		b21 = decrypt(c2, DECODE_TABLE[chars[c2]])
		b3 = decrypt(b0, DECODE_TABLE[chars[b0]])

		ret[i * 3 ] =



# import re
# for line in platform.strip().split('\n'):
# 	platform, meaning = re.split(r'\s+', line)[:2]

# 	print("insert into checklist_cookie_partner_dict(raw_platform, platform) values ('{0}', '{1}');".format(meaning, platform))
# 	print
# 	# print(platform, meaning, base64.urlsafe_b64encode(platform))

# 		#binascii.b2a_base64(meaning), base64.decodestring(binascii.b2a_base64(meaning)), str(bsafe_base64_decode(meaning)))



