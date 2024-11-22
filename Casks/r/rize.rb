cask "rize" do
  arch arm: "arm64", intel: "x64"

  version "1.5.2"
  sha256  arm:   "e2fda6ef3fba3190eb72e52cefee788107db1b682d1becef5c3d8836065b012c",
          intel: "ced900887e57f7b956efb2c6e194d7993c272be7a8710ee07bae637359e26997"

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