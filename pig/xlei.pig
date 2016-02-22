SET pig.exec.reducers.max 519;
SET io.sort.factor 200;
SET io.sort.mb 640;
SET mapred.reduce.parallel.copies 200;
SET pig.splitCombination true;
SET pig.maxCombinedSplitSize 536870912;
SET mapred.compress.map.output false;
SET mapred.map.output.compression.codec com.hadoop.compression.lzo.LzopCodec;

-------------------------------------------------------------------------------


-- 张磊现有的 7 万 + 人群

-- xleiid = load '/user/xlei.zhang/audience_relate/baoshijie/pyid_idfa_shandong/2015/11/09/pyids' as (pyid:chararray);



-- 加载日志的模板

-- 加载曝光点击日志

run -param log_name=raw_log_imp -param src_folder='/user/root/flume/express/2015/11/{10,11,12,13,14,15,16,17,18}/*/imp*' /data/production/data_report/opt_reports/PigCommon/load_express_impclk.pig;

imp_filter = filter raw_log_imp by IdStrategyId == '152871';
pyid_imp = foreach imp_filter generate UserId as pyid;
STORE pyid_imp INTO '/user/jinyong.yang/shenzhou/shandong/renqun/zhangxlei/pyids_imp/';

-- 加载点击日志
run -param log_name=raw_log_click -param src_folder='/user/root/flume/express/2015/11/{10,11,12,13,14,15,16,17,18}/*/click*' /data/production/data_report/opt_reports/PigCommon/load_express_impclk.pig;

clk_filter = filter raw_log_click by IdStrategyId == '152871';
pyid_clk = foreach clk_filter generate UserId as pyid;
STORE pyid_clk INTO '/user/jinyong.yang/shenzhou/shandong/renqun/zhangxlei/pyids_clk/';

-- 加载转化日志
run -param log_name=raw_log_cvt -param src_folder='/user/root/flume/express/2015/11/{10,11,12,13,14,15,16,17,18}/*/cvt*' /data/production/data_report/opt_reports/PigCommon/load_express_cvt.pig;

cvt_filter = filter raw_log_cvt by StrategyId == '152871';
pyid_cvt = foreach cvt_filter generate UserId as pyid;
STORE pyid_cvt INTO '/user/jinyong.yang/shenzhou/shandong/renqun/zhangxlei/pyids_cvt/';

