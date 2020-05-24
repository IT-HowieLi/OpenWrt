#!/bin/bash
#=============================================================
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part1.sh
# Description: OpenWrt DIY script part 1 (Before Update feeds)
# Lisence: MIT
# Author: P3TERX
# Blog: https://p3terx.com
#=============================================================

# Uncomment a feed source
sed -i 's/^#\(.*helloworld\)/\1/' feeds.conf.default

# Add a feed source
#sed -i '$a src-git lienol https://github.com/Lienol/openwrt-package' feeds.conf.default

# Modify Default Theme
sed -i '/exit 0/i uci batch <<-EOF' package/lean/default-settings/files/zzz-default-settings
sed -i '/exit 0/i    set luci.themes.Argon=/luci-static/argon' package/lean/default-settings/files/zzz-default-settings
sed -i '/exit 0/i    set luci.main.mediaurlbase=/luci-static/argon' package/lean/default-settings/files/zzz-default-settings
sed -i '/exit 0/i    commit luci' package/lean/default-settings/files/zzz-default-settings
sed -i '/exit 0/i EOF' package/lean/default-settings/files/zzz-default-settings

# Update Luci theme argon  
rm -rf package/lean/luci-theme-argon  
git clone -b 18.06 https://github.com/jerrykuku/luci-theme-argon.git package/lean/luci-theme-argon

# DownLoad OpenClash
mkdir package/luci-app-openclash
cd package/luci-app-openclash
git init
git remote add -f origin https://github.com/vernesong/OpenClash.git
git config core.sparsecheckout true
echo "luci-app-openclash" >> .git/info/sparse-checkout
git pull origin master
git branch --set-upstream-to=origin/master master
cd -

# integration clash core 实现编译更新后直接可用，不用手动下载clashr内核
# https://github.com/frainzy1477/clashrdev
curl -sL -m 30 --retry 2 https://github.com/frainzy1477/clashrdev/releases/download/v0.19.0.2/clashr-linux-amd64-v0.19.0.2.gz -o /tmp/clash.gz
gunzip -c clash.gz > /tmp/clash >/dev/null 2>&1
chmod +x /tmp/clash >/dev/null 2>&1
mkdir -p package/luci-app-openclash/luci-app-openclash/files/etc/openclash/core
mv /tmp/clash package/luci-app-openclash/luci-app-openclash/files/etc/openclash/core/clash >/dev/null 2>&1
rm -rf /tmp/clash.gz >/dev/null 2>&1
