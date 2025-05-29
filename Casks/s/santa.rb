cask "santa" do
  version "2025.5"
  sha256 "1d79af9cde4fa17279d8e5ccd74021fcd2685581590659addb25b6389c6ef55a"

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