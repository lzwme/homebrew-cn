cask "rize" do
  arch arm: "arm64", intel: "x64"

  version "1.5.4"
  sha256  arm:   "c78c975fd4b4ac2c32d43fb39b90298188171b312e0689140a204f4204f5f099",
          intel: "a0e8f96b81c7c7918bb054c966901403df7bb83775c93e58c6076925e551edf8"

  url "https:github.comrize-ioluareleasesdownloadv#{version}Rize-#{version}-#{arch}.dmg",
      verified: "github.comrize-iolua"
  name "Rize"
  desc "AI time tracker"
  homepage "https:rize.io"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: ">= :catalina"

  app "Rize.app"

  zap trash: [
    "~LibraryApplication SupportRize",
    "~LibraryCachesio.rize",
    "~LibraryCachesio.rize.ShipIt",
    "~LibraryHTTPStoragesio.rize",
    "~LibraryPreferencesio.rize.plist",
    "~LibrarySaved Application Stateio.rize.savedState",
  ]
end