cask "logi-options-plus" do
  version "1.34.0.376143"
  sha256 :no_check

  url "https://download01.logi.com/web/ftp/pub/techsupport/optionsplus/logioptionsplus_installer.zip",
      verified: "download01.logi.com/web/ftp/pub/techsupport/optionsplus/"
  name "Logitech Options+"
  desc "Software for Logitech devices"
  homepage "https://www.logitech.com/en-us/software/logi-options-plus.html"

  livecheck do
    url :url
    strategy :extract_plist do |versions|
      versions.values.map(&:version).compact.first
    end
  end

  auto_updates true
  depends_on macos: ">= :catalina"

  installer manual: "logioptionsplus_installer.app"

  uninstall launchctl: [
              "com.logi.cp-dev-mgr",
              "com.logi.optionsplus",
              "com.logi.optionsplus.agent",
              "com.logi.optionsplus.updater",
            ],
            quit:      [
              "com.logi.cp-dev-mgr",
              "com.logi.optionsplus",
              "com.logi.optionsplus.agent",
              "com.logi.optionsplus.updater",
            ],
            delete:    [
              "/Applications/logioptionsplus.app",
              "/Library/LaunchAgents/com.logi.optionsplus.plist",
              "/Library/LaunchDaemons/com.logi.optionsplus.updater.plist",
            ]

  zap trash: [
    "/Users/Shared/LogiOptionsPlus",
    "~/Library/Application Support/LogiOptionsPlus",
    "~/Library/Application Support/logioptionsplus",
    "~/Library/Preferences/com.logi.cp-dev-mgr.plist",
    "~/Library/Preferences/com.logi.optionsplus.plist",
    "~/Library/Saved Application State/com.logi.optionsplus.savedState",
  ]

  caveats do
    reboot
  end
end