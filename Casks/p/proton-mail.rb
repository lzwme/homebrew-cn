cask "proton-mail" do
  arch arm: "arm64", intel: "x64"

  version "1.0.2"
  sha256 arm:   "e4c17499fc19b582d885210624c2dbab064f0726e19c5a6d2a706cac6df8ce67",
         intel: "cdf029256e48b55ea83b1e704874b55fb0f993c1ef3d165aa5fa572e3d313bd3"

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