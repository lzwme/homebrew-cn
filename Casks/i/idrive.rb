cask "idrive" do
  version "4.0.0.51,103125"
  sha256 "eefc31fe144fb53f33079be31b9b1e250d69d31ddf2e3cc32d8c696c8a604ecd"

  url "https://static.idriveonlinebackup.com/downloads/#{version.csv.second}/IDrive.dmg",
      verified: "static.idriveonlinebackup.com/downloads/"
  name "iDrive"
  desc "Cloud backup and storage solution"
  homepage "https://www.idrive.com/"

  # The upstream download page appends a UNIX epoch timestamp (in milliseconds)
  # to the JavaScript URL, so we do the same (in case it affects the returned data).
  livecheck do
    url "https://static.idriveonlinebackup.com/downloads/version_mac.js?v=#{DateTime.now.strftime("%Q")}"
    strategy :page_match do |page|
      version_match = page.match(/Version:?\s*v?(\d+(?:\.\d+)+)/i)
      next if version_match.blank?

      id_match = page.match(%r{downloads/([^/]+?)/}i)
      next if id_match.blank?

      "#{version_match[1]},#{id_match[1]}"
    end
  end

  pkg "IDrive.pkg"

  uninstall launchctl: [
              "com.iDrive.FinderPluginApp",
              "com.prosoftnet.DaemonHelper",
              "com.prosoftnet.idrivedaemon",
              "com.prosoftnet.idsyncdaemon",
              "IDriveDaemon",
              "IDSyncDaemon",
              "IDWifiManager",
            ],
            quit:      [
              "com.prosfotnet.IDWifiManager",
              "com.prosoftnet.IDrive",
              "com.prosoftnet.IDriveDaemon",
              "com.prosoftnet.IDriveMonitor",
            ],
            pkgutil:   [
              "com.idrive.IDrive",
              "com.profsoftnet.idrive.*",
            ]

  zap trash: [
    "/Library/Application Support/IDriveforMac",
    "~/Library/Application Support/IDriveforMac",
    "~/Library/Caches/com.prosoftnet.IDriveMonitor",
    "~/Library/Preferences/com.prosoftnet.IDrive.plist",
    "~/Library/Preferences/com.prosoftnet.IDriveMonitor.plist",
  ]
end