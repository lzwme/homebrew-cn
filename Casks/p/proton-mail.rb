cask "proton-mail" do
  arch arm: "arm64", intel: "x64"

  version "1.0.4"
  sha256 arm:   "72169fad0b27f2d72ab8ce0601ad3ae86ac3831cb1c21bb96fae72c7abb7214a",
         intel: "a302e5e27722f6b18ae7bf1713b551a4d0c68b3e9cb3ef872cf54f297ad32f09"

  url "https:github.comProtonMailinbox-desktopreleasesdownloadv#{version}Proton.Mail-#{version}-#{arch}.dmg",
      verified: "github.comProtonMailinbox-desktop"
  name "Proton Mail"
  desc "Client for Proton Mail and Proton Calendar"
  homepage "https:proton.memail"

  auto_updates true
  depends_on macos: ">= :catalina"

  app "Proton Mail.app"

  zap trash: [
    "~LibraryApplication SupportProton Mail",
    "~LibraryCachesch.protonmail.desktop",
    "~LibraryCachesch.protonmail.desktop.ShipIt",
    "~LibraryHTTPStoragesch.protonmail.desktop",
    "~LibraryLogsProton Mail",
    "~LibraryPreferencesch.protonmail.desktop.plist",
    "~LibrarySaved Application Statech.protonmail.desktop.savedState",
  ]
end