cask "santa" do
  version "2025.6"
  sha256 "8bee8c183397e84726a92c12de92c5525d115d4173c5c5de2a442d6299beac2c"

  url "https:github.comnorthpolesecsantareleasesdownload#{version}santa-#{version}.dmg"
  name "Santa"
  desc "Binary authorization system"
  homepage "https:github.comnorthpolesecsanta"

  pkg "santa-#{version}.pkg"

  uninstall early_script: {
              executable:   "ApplicationsSanta.appContentsMacOSSanta",
              args:         ["--unload-system-extension"],
              sudo:         true,
              must_succeed: false,
            },
            launchctl:    [
              "com.northpolesec.santa",
              "com.northpolesec.santa.bundleservice",
              "com.northpolesec.santa.metricservice",
              "com.northpolesec.santa.syncservice",
              "com.northpolesec.santad",
            ],
            pkgutil:      "com.northpolesec.santa",
            delete:       [
              "ApplicationsSanta.app",
              "usrlocalbinsantactl",
            ]

  zap delete: [
        "vardbsanta",
        "varlogsanta*",
      ],
      trash:  [
        "privateetcaslcom.northpolesec.santa.asl.conf",
        "privateetcnewsyslog.dcom.northpolesec.santa.newsyslog.conf",
      ]
end