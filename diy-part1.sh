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
