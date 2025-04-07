cask "santa" do
  version "2025.3"
  sha256 "06a33253a015be318503523df054771786a2d71d99f5e679329f32968d808cc1"

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