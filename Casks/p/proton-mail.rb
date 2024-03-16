cask "proton-mail" do
  arch arm: "arm64", intel: "x64"

  version "1.0.0"
  sha256 arm:   "8db84204140f3407c44ad5f8d883b56112b69f99c17c349387b83eeee8c16668",
         intel: "014ca5e05222adcb3ed6553c1da2c74a458cea12ef08f6efb52c8f2bb8eb66cc"

  url "https:github.comProtonMailinbox-desktopreleasesdownloadv#{version}Proton-Mail-#{version}-#{arch}.dmg",
      verified: "github.comProtonMailinbox-desktop"
  name "Proton Mail"
  desc "Client for Proton Mail"
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