cask "tabby" do
  arch arm: "arm64", intel: "x86_64"

  version "1.0.219"
  sha256 arm:   "82f49b90631790a3b25adebe60d8f1db42d4767f65f9ce91cb2a5fcd0d04526f",
         intel: "a3dbed1f3ab9523fc54310e13ace59939fad65f11b17c2090512b350ddb6b633"

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