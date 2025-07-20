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

# golang only for 21.xx and 23.xx
#rm -rf feeds/packages/lang/golang
#git clone --depth 1 https://github.com/sbwml/packages_lang_golang feeds/packages/lang/golang

# fix alist build fail issue -> https://github.com/sbwml/luci-app-alist
sudo -E apt-get -qq install libfuse-dev

### alist
#rm -rf feeds/packages/net/alist
#rm -rf feeds/luci/applications/luci-app-alist
#git clone --depth 1 https://github.com/sbwml/openwrt-alist.git package/custom/luci-app-alist

### wechatpush
#rm -rf feeds/luci/applications/luci-app-wechatpush
#git clone --depth 1 https://github.com/tty228/luci-app-wechatpush.git package/custom/luci-app-wechatpush

### use official openclash source and Mihomo
#rm -rf feeds/luci/applications/luci-app-openclash
#git clone --depth 1 https://github.com/vernesong/OpenClash.git package/custom/luci-app-openclash
#git clone --depth 1 https://github.com/morytyann/OpenWrt-mihomo.git package/custom/OpenWrt-mihomo


# fix upgrade failure issue
#rm -f target/linux/mediatek/filogic/base-files/lib/upgrade/platform.sh
#cp $GITHUB_WORKSPACE/JDCloud-AX6000-Baili-immortalwrt/mod_files/platform.sh target/linux/mediatek/filogic/base-files/lib/upgrade/platform.sh

# remove openwrt/package  and use immortalwrt/package
# rm -rf feeds/packages/net/zerotier

# fix linux kernel 6.6.x udp issue
# compare files with https://github.com/coolsnowwolf/lede/tree/master/target/linux/generic then del all different files
#rm -rf target/linux/generic/hack-6.6/600-net-enable-fraglist-GRO-by-default.patch
#rm -rf target/linux/generic/pending-6.6/680-net-add-TCP-fraglist-GRO-support.patch
#rm -rf target/linux/generic/pending-6.6/681-net-remove-NETIF_F_GSO_FRAGLIST-from-NETIF_F_GSO_SOF.patch
#rm -rf target/linux/generic/pending-6.6/684-gso-fix-gso-fraglist-segmentation-after-pull-from-fr.patch
#rm -rf target/linux/generic/pending-6.6/685-net-gso-fix-tcp-fraglist-segmentation-after-pull-fro.patch
#rm -rf target/linux/generic/backport-6.6/611-01-v6.11-udp-Allow-GSO-transmit-from-devices-with-no-checksum.patch
#rm -rf target/linux/generic/backport-6.6/611-02-v6.11-net-Make-USO-depend-on-CSUM-offload.patch
#rm -rf target/linux/generic/backport-6.6/611-03-v6.11-udp-Fall-back-to-software-USO-if-IPv6-extension-head.patch

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

# Modify default IP
#sed -i 's/192.168.1.1/192.168.50.5/g' package/base-files/files/bin/config_generate
##-----------------Del duplicate packages------------------
#rm -rf feeds/packages/net/open-app-filter
##-----------------Add OpenClash dev core------------------
#curl -sL -m 30 --retry 2 https://raw.githubusercontent.com/vernesong/OpenClash/core/master/dev/clash-linux-arm64.tar.gz -o /tmp/clash.tar.gz
#tar zxvf /tmp/clash.tar.gz -C /tmp >/dev/null 2>&1
#chmod +x /tmp/clash >/dev/null 2>&1
#mkdir -p feeds/luci/applications/luci-app-openclash/root/etc/openclash/core
#mv /tmp/clash feeds/luci/applications/luci-app-openclash/root/etc/openclash/core/clash >/dev/null 2>&1
#rm -rf /tmp/clash.tar.gz >/dev/null 2>&1
##-----------------Delete DDNS's examples-----------------
sed -i '/myddns_ipv4/,$d' feeds/packages/net/ddns-scripts/files/etc/config/ddns

# enable wifi by default
#sed -i "s/set \${s}\.disabled='[^']*'/set \${s}.disabled='0'/g"  package/network/config/wifi-scripts/files/lib/wifi/mac80211.uc

# update default SSID
#sed -i "s/set \${si}\.ssid='\${defaults?.ssid || \"OpenWrt\"}'/set \${si}.ssid='\${defaults?.ssid || \"OpenWrt-WiFi\"}'/g" package/network/config/wifi-scripts/files/lib/wifi/mac80211.uc

# fix 802.11r +PSK-SAE ,apple device can't connect issue
# ref https://github.com/openwrt/openwrt/issues/7858
#??? sed -i 's/\[ "${ieee80211w:-0}" -gt 0 \] \&\& append wpa_key_mgmt "WPA-PSK-SHA256"/\[ "${ieee80211w:-0}" -gt 1 \] \&\& append wpa_key_mgmt "WPA-PSK-SHA256"/g' package/network/config/wifi-scripts/files/lib/netifd/hostapd.sh
