cask "proton-mail-bridge" do
  version "3.18.0"
  sha256 "c100834b531517649c2edba7898b0ab74511dbd5883a9fef9426ffa949cae9a4"

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