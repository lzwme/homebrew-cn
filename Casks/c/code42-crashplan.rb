cask "code42-crashplan" do
  version "8.2.3,1525200006823,22"
  sha256 "3e2cafdcf35786e90a909961a8f839a4d9f31ebe68a236d52d97d5635ac5f03f"

  url "https://download.code42.com/installs/client-package-repository/#{version.csv.first}/#{version.csv.third}/install/Code42_#{version.tr(",", "_")}_Mac.dmg",
      verified: "download.code42.com/"
  name "Code42 CrashPlan"
  desc "Endpoint backup and recovery"
  homepage "https://www.crashplan.com/"

  no_autobump! because: :requires_manual_review

  disable! date: "2024-12-16", because: :discontinued

  auto_updates true

  pkg "Install Code42.pkg"

  uninstall launchctl: "com.backup42.desktop",
            script:    {
              executable: "Uninstall.app/Contents/Resources/uninstall.sh",
              sudo:       true,
            },
            pkgutil:   "com.code42.app.pkg"
end