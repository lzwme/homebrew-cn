cask "pritunl" do
  version "1.3.4059.45"
  sha256 "daf6f7b40c8b8813b781ae3df61cff86fb5103565504b5bde2992ce0d0e5f642"

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