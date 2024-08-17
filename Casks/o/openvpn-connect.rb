cask "openvpn-connect" do
  arch arm: "arm64", intel: "x86_64"

  version "3.5.0,5200"
  sha256 "a8f35d83fafac92d065c2469063d8cdfc0a07e5d62aca4db06f4af005fe91a8e"

  url "https://swupdate.openvpn.net/downloads/connect/openvpn-connect-#{version.csv.first}.#{version.csv.second}_signed.dmg"
  name "OpenVPN Connect client"
  desc "Client program for the OpenVPN Access Server"
  homepage "https://openvpn.net/client-connect-vpn-for-mac-os/"

  livecheck do
    url "https://openvpn.net/downloads/openvpn-connect-v#{version.major}-macos.dmg"
    regex(%r{/openvpn[._-]connect[._-]v?(\d+(?:\.\d+)+)\.(\d+)[._-]signed\.dmg}i)
    strategy :header_match do |headers, regex|
      headers["location"].scan(regex).map { |match| "#{match[0]},#{match[1]}" }
    end
  end

  pkg "OpenVPN_Connect_#{version.csv.first.dots_to_underscores}(#{version.csv.second})_#{arch}_Installer_signed.pkg"

  uninstall launchctl:  [
              "org.openvpn.client",
              "org.openvpn.helper",
            ],
            quit:       "org.openvpn.client.app",
            login_item: "OpenVPN Connect",
            pkgutil:    [
              "org.openvpn.client.pkg",
              "org.openvpn.client_framework.pkg",
              "org.openvpn.client_launch.pkg",
              "org.openvpn.client_uninstall.pkg",
              "org.openvpn.helper_framework.pkg",
              "org.openvpn.helper_launch.pkg",
            ],
            delete:     [
              "/Applications/OpenVPN Connect",
              "/Applications/OpenVPN Connect.app",
            ]

  zap script: {
        executable: "security",
        args:       ["delete-keychain", "openvpn.keychain-db"],
      },
      trash:  [
        "~/Library/Application Support/OpenVPN Connect",
        "~/Library/Logs/OpenVPN Connect",
        "~/Library/Preferences/org.openvpn.client.app.helper.plist",
        "~/Library/Preferences/org.openvpn.client.app.plist",
        "~/Library/Saved Application State/org.openvpn.client.app.savedState",
      ]
end