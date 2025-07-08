cask "logmein-hamachi" do
  version "2.1.827"
  sha256 :no_check

  url "https://secure.logmein.com/LogMeInHamachi.zip",
      verified: "logmein.com/"
  name "LogMeIn Hamachi"
  desc "Hosted VPN service that lets you securely extend LAN-like networks"
  homepage "https://vpn.net/"

  no_autobump! because: :requires_manual_review

  deprecate! date: "2024-07-07", because: :unmaintained
  disable! date: "2025-07-07", because: :unmaintained

  installer manual: "LogMeInHamachiInstaller.app"

  uninstall script: {
    executable: "/Applications/LogMeIn Hamachi/HamachiUninstaller.app/Contents/Resources/uninstaller.sh",
    sudo:       true,
  }

  zap trash: [
    "/Library/Application Support/LogMeIn Hamachi",
    "~/Library/Application Support/LogMeIn Hamachi",
  ]
end