cask "pritunl" do
  version "1.3.4024.40"
  sha256 "e5921f0e1338024d4807a26317f5cbf49170b28a9c979875f3dfb83747f4aa6a"

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