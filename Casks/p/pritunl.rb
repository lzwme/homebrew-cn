cask "pritunl" do
  version "1.3.4051.36"
  sha256 "1fa3781ba262a5ad1d800f00860ce71c8ebecc612c3ec2b74b187edcad41e1a5"

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