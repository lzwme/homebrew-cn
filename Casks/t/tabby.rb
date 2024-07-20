cask "tabby" do
  arch arm: "arm64", intel: "x86_64"

  version "1.0.211"
  sha256 arm:   "4cd46ad9d9a0a856a0b41e48a9466e190cf48f197019cebe2ca14a52add25149",
         intel: "ce46751727761c7222df2f0616c9ae246d9f429c5c1ace95226758ec05828cf8"

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