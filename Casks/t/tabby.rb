cask "tabby" do
  arch arm: "arm64", intel: "x86_64"

  version "1.0.216"
  sha256 arm:   "b51247d87a4ebb979f737d045d8c9303333cb4a5a3ea4d73c7d738868f124718",
         intel: "ac3d83b52123472206ddcb81f5408d4bc28594c796435e03c0783e37cefdaad7"

  url "https:github.comEugenytabbyreleasesdownloadv#{version}tabby-#{version}-macos-#{arch}.zip",
      verified: "github.comEugenytabby"
  name "Tabby"
  name "Terminus"
  desc "Terminal emulator, SSH and serial client"
  homepage "https:eugeny.github.iotabby"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true

  app "Tabby.app"

  zap trash: [
    "~LibraryApplication Supporttabby",
    "~LibraryPreferencesorg.tabby.helper.plist",
    "~LibraryPreferencesorg.tabby.plist",
    "~LibrarySaved Application Stateorg.tabby.savedState",
    "~LibraryServicesOpen Tabby here.workflow",
    "~LibraryServicesPaste path into Tabby.workflow",
  ]
end