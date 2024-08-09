cask "proton-mail" do
  arch arm: "arm64", intel: "x64"

  version "1.0.6"
  sha256 arm:   "4206e235c99f432e6b8d654bc925b4a1b6b91ea91e2fc15c239ad539c21bc499",
         intel: "4206e235c99f432e6b8d654bc925b4a1b6b91ea91e2fc15c239ad539c21bc499"

  url "https:github.comProtonMailinbox-desktopreleasesdownload#{version}Proton.Mail-#{version}-#{arch}.dmg",
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