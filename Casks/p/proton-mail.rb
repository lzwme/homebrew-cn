cask "proton-mail" do
  arch arm: "arm64", intel: "x64"

  version "1.0.5"
  sha256 arm:   "4a366e7fc63db684eec8bd1e511c2f51fd6fd6f98aea1c6093a27d9d79549165",
         intel: "4a366e7fc63db684eec8bd1e511c2f51fd6fd6f98aea1c6093a27d9d79549165"

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