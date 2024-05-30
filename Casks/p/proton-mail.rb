cask "proton-mail" do
  arch arm: "arm64", intel: "x64"

  version "1.0.3"
  sha256 arm:   "c691cfec43b6876209e8cca8e35b89cb5d20805027341128bcaf35c07234540e",
         intel: "b042e8f30820f7ef8bdbf7a74d7f35bf948234bd6b31d9fa533cc11d388b96aa"

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