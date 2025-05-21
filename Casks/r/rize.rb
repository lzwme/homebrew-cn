cask "rize" do
  arch arm: "arm64", intel: "x64"

  version "1.5.5"
  sha256 arm:   "479ec2dda5ab87f4ae2189d2d9829bc9e4fff185d92cd04cd1b2f63b51497127",
         intel: "e0afbb2ad8acc2309a1b10569dc0d9bf2bc408f34d6857f719850e819e85b4a5"

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