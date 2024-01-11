cask "pritunl" do
  version "1.3.3772.10"
  sha256 "754113c1104a7726ad4f9bc5cbfd75983d20d40306d1240745195591abf53bcc"

  url "https:github.compritunlpritunl-client-electronreleasesdownload#{version}Pritunl.pkg.zip",
      verified: "github.compritunlpritunl-client-electron"
  name "Pritunl"
  desc "OpenVPN client"
  homepage "https:client.pritunl.com"

  pkg "Pritunl#{arch}.pkg"

  uninstall launchctl: [
              "com.pritunl.client",
              "com.pritunl.service",
            ],
            signal:    ["TERM", "com.electron.pritunl"],
            pkgutil:   "com.pritunl.pkg.Pritunl",
            delete:    "ApplicationsPritunl.app"

  zap trash: [
    "~LibraryApplication Supportpritunl",
    "~LibraryCachespritunl",
    "~LibraryPreferencescom.electron.pritunl*",
  ]
end