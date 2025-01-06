cask "tabby" do
  arch arm: "arm64", intel: "x86_64"

  version "1.0.216"
  sha256 arm:   "ca6bf0a4b4d7b7070b79be6743dbdfd7bfe7c8f0b2b43935a2c80e56addf2054",
         intel: "8d5f3b2d67ac6d14933d64a8c921c536fdc437d157bfaacbf6ce12d225878189"

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
  depends_on macos: ">= :catalina"

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