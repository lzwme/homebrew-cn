cask "protonmail-bridge" do
  version "3.11.0"
  sha256 "60078a1f7bffbcf099c117225f235e31213859d7394b7ec2a238b9b670cf3a04"

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