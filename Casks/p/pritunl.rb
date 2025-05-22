cask "pritunl" do
  version "1.3.4269.93"
  sha256 "1210bc4eb9cac720222ecdcbef0bc6915bc5b248090f23ff9a7475173a2f2690"

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