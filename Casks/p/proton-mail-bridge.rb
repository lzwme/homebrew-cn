cask "proton-mail-bridge" do
  version "3.21.1"
  sha256 "62efee44e16ab3031b3b4bfb2b156cd02e83a49aeec1ff300b143a5862297f97"

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