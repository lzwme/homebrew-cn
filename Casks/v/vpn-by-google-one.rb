cask "vpn-by-google-one" do
  version "1.7.0.0"
  sha256 :no_check

  url "https:dl.google.comgoogle-oneVpnByGoogleOne.dmg"
  name "VPN by Google One"
  desc "VPN provided by Google One"
  homepage "https:one.google.comaboutvpn"

  livecheck do
    url :url
    strategy :extract_plist
  end

  auto_updates true
  depends_on macos: ">= :big_sur"

  pkg "VpnByGoogleOne.pkg"

  # Some launchctl and pkgutil items are shared with other Google apps, they should only be removed in the zap stanza
  # See: https:github.comHomebrewhomebrew-caskpull92704#issuecomment-727163169
  # launchctl: com.google.keystone.daemon, com.google.keystone.system.agent, com.google.keystone.system.xpcservice
  # pkgutil: com.google.pkg.Keystone
  uninstall launchctl: "VPN by Google One",
            quit:      "com.google.one",
            pkgutil:   "com.google.one"

  zap launchctl: [
        "com.google.keystone.agent",
        "com.google.keystone.daemon",
        "com.google.keystone.system.agent",
        "com.google.keystone.system.xpcservice",
        "com.google.keystone.xpcservice",
      ],
      pkgutil:   "com.google.pkg.Keystone",
      trash:     [
        "~LibraryApplication Scriptscom.google.one",
        "~LibraryContainerscom.google.one",
        "~LibraryGroup ContainersEQHXZ8M8AV.com.google.one",
        "~LibraryLaunchAgentsVPN by Google One.plist",
      ]
end