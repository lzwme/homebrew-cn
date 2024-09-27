cask "tabby" do
  arch arm: "arm64", intel: "x86_64"

  version "1.0.215"
  sha256 arm:   "d725d3f1723e5155392d8f3fce22027e88e511fe5074458f30a71210c5e5d2a1",
         intel: "409be3dbce51338b766adb40127adab953fa1aac233c32c1d2390800499edc9f"

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