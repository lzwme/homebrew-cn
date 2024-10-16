cask "rize" do
  arch arm: "arm64", intel: "x64"

  version "1.4.4"
  sha256  arm:   "8b187bd570f5c704a40d07cd3f4e7a02de6bffd34f04d224130c147b31682198",
          intel: "d9524538d70d19395fd9928958db5a8dae9245ec1edbdab42597fca811ffe537"

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