cask "protonmail-bridge" do
  version "3.15.0"
  sha256 "3cc164c816147686cf87c6a1dabb099008edad28b18810b3348d97a1d18f38f3"

  url "https:github.comProtonMailproton-bridgereleasesdownloadv#{version}Bridge-Installer.dmg",
      verified: "github.comProtonMailproton-bridge"
  name "Proton Mail Bridge"
  desc "Bridges Proton Mail to email clients supporting IMAP and SMTP protocols"
  homepage "https:proton.memailbridge"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true

  app "Proton Mail Bridge.app"

  uninstall launchctl: "Proton Mail Bridge",
            quit:      "com.protonmail.bridge"

  zap trash: [
    "~LibraryApplication Supportprotonmail",
    "~LibraryCachesProton AGProton Mail Bridge",
    "~LibraryCachesprotonmail",
  ]
end