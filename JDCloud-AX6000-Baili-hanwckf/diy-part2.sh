#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#
#  steven ->
# https://github.com/stupidloud/nanopi-openwrt/blob/master/scripts/merge_packages.sh
# eg merge_package https://github.com/immortalwrt/packages.git packages/net/zerotier
#   merge_package 仓库路径.git  仓库名/目录1/目录2/ .../目标目录
function merge_package(){
    repo=`echo $1 | rev | cut -d'/' -f 1 | rev`
    pkg=`echo $2 | rev | cut -d'/' -f 1 | rev`
    find package/ -follow -name $pkg -not -path "package/custom/*" | xargs -rt rm -rf
    git clone --depth=1 --single-branch $1
    mv $2 package/custom/
    rm -rf $repo
}
rm -rf package/custom; 
mkdir package/custom
# <----





# New version golang
#rm -rf feeds/packages/lang/golang
#rm -rf packages/lang/golang
#git clone --depth 1 https://github.com/sbwml/packages_lang_golang -b 23.x feeds/packages/lang/golang
#merge_package https://github.com/immortalwrt/packages.git packages/lang/golang

# alist
sudo -E apt-get -qq install libfuse-dev
rm -rf feeds/packages/net/alist
rm -rf feeds/luci/applications/luci-app-alist
git clone --depth 1 https://github.com/sbwml/openwrt-alist.git package/custom/luci-app-alist



# smartdns
#rm -rf feeds/packages/net/smartdns
#git clone --depth 1 https://github.com/pymumu/openwrt-smartdns.git package/custom/smartdns
# rm -rf feeds/luci/applications/luci-app-smartdns
# git clone --depth 1 https://github.com/pymumu/luci-app-smartdns.git feeds/luci/applications/luci-app-smartdns


# FROS是一款路由器防沉迷系统，支持常见的游戏、视频等APP过滤，如抖音、斗鱼、王者荣耀、和平精英等，并支持 APP使用时长统计，小孩网课必备神器。
# git clone -b fros-21.02 --depth 1 https://github.com/destan19/fros-packages-immortalwrt-mt798x.git package/custom/fros-packages
# sed -i "s/\$(CONFIG_TARGET_SUBTARGET)/mt7981/g"  package/custom/fros-packages/fros-apps/Makefile

# 预置openclash内核
mkdir -p files/etc/openclash/core
CLASH_META_URL="https://raw.githubusercontent.com/vernesong/OpenClash/core/master/meta/clash-linux-arm64.tar.gz"
GEOIP_URL="https://github.com/MetaCubeX/meta-rules-dat/releases/download/latest/geoip-lite.dat"
GEOSITE_URL="https://github.com/MetaCubeX/meta-rules-dat/releases/download/latest/geosite.dat"
wget -qO- $CLASH_META_URL | tar xOvz > files/etc/openclash/core/clash_meta
wget -qO- $GEOIP_URL > files/etc/openclash/GeoIP.dat
wget -qO- $GEOSITE_URL > files/etc/openclash/GeoSite.dat
# 给内核权限
chmod +x files/etc/openclash/core/clash*

# steven <-

# Modify default IP
#sed -i 's/192.168.1.1/192.168.50.5/g' package/base-files/files/bin/config_generate
##-----------------Del duplicate packages------------------
rm -rf feeds/packages/net/open-app-filter
##-----------------Add OpenClash dev core------------------
#curl -sL -m 30 --retry 2 https://raw.githubusercontent.com/vernesong/OpenClash/core/master/dev/clash-linux-arm64.tar.gz -o /tmp/clash.tar.gz
#tar zxvf /tmp/clash.tar.gz -C /tmp >/dev/null 2>&1
#chmod +x /tmp/clash >/dev/null 2>&1
#mkdir -p feeds/luci/applications/luci-app-openclash/root/etc/openclash/core
#mv /tmp/clash feeds/luci/applications/luci-app-openclash/root/etc/openclash/core/clash >/dev/null 2>&1
#rm -rf /tmp/clash.tar.gz >/dev/null 2>&1
##-----------------Delete DDNS's examples-----------------
sed -i '/myddns_ipv4/,$d' feeds/packages/net/ddns-scripts/files/etc/config/ddns
##-----------------Manually set CPU frequency for MT7986A-----------------
sed -i '/"mediatek"\/\*|\"mvebu"\/\*/{n; s/.*/\tcpu_freq="2.0GHz" ;;/}' package/emortal/autocore/files/generic/cpuinfo
