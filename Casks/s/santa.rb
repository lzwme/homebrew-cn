cask "santa" do
  version "2025.4"
  sha256 "ebdc0289576836ace519489ba8a61569bf3c6874b12159dce7b8e8ac73912ee9"

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