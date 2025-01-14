cask "proton-mail-bridge" do
  version "3.16.0"
  sha256 "70e198e05dd7c711159934a91eac0331cf3e69297e815d7afb783de8a7b80296"

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