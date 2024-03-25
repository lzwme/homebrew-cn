cask "proton-mail" do
  arch arm: "arm64", intel: "x64"

  version "1.0.1"
  sha256 arm:   "b3bdb8003bda8cd0348fbdc246aa86b252c90a4da0d1ecc0a2a0ba618a146c11",
         intel: "b07c2902d084787cf676074af38728f4fda36a0e088aaca576a4ba35c3a4a93f"

  url "https:github.comProtonMailinbox-desktopreleasesdownloadv#{version}Proton-Mail-#{version}-#{arch}.dmg",
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