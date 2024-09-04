cask "rize" do
  arch arm: "arm64", intel: "x64"

  version "1.3.6"
  sha256  arm:   "324afeb1a420ec8343ae356783463f342c1fe7eba92bc9421762426f23d352cf",
          intel: "1f3800f60a72a206bc784bcc0cdab8074c6f78a1706ea5af1c0ab981244c853b"

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