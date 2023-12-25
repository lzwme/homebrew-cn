cask "pritunl" do
  arch arm: ".arm64"

  version "1.3.3709.64"
  sha256 arm:   "20f0212dce7d97fe2703804783f0489222d7f63db4b093fc101d927b6d6cab9d",
         intel: "fb811e75eb2d9a14ff119d5cb1b8e47d885a7d332420299030d90a08e1c6787d"

  url "https:github.compritunlpritunl-client-electronreleasesdownload#{version}Pritunl#{arch}.pkg.zip",
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