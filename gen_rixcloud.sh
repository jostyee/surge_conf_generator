#!/bin/sh

set -ex

update_log=update_date_rixcloud.log
# 先判断时间戳文件是否存在，没有则生成一个
if [ ! -f "$update_log" ]; then
  echo "creating $update_log"
  touch "$update_log"
fi

last_date=$(<$update_log)
#update_date=$(grep 'Version' rixCloud.conf | awk '{print $2}')
update_date=$(awk '/Version/ {print $2}' rixCloud.conf)

if [[ -n $last_date && $update_date = $last_date ]]
then
  echo "config is already updated, skip generating"
  exit 0
fi

# 记录下最新的配置更新日期
echo $update_date > $update_log

IFS=" "
proxies=$(grep "中继" rixCloud.conf | grep -v "select")
proxy_rixcloud="[Proxy]\n"${proxies}"\n\n[Proxy Group]\n"
proxy_group=$(grep "select" rixCloud.conf)
proxy_rixcloud=${proxy_rixcloud}${proxy_group}

rule=$(<surge-cn.conf)
placeholder='\#placeholder'
echo "${rule/$placeholder/$proxy_rixcloud}" > surge_rixcloud.conf

echo "rixCloud config updated"
