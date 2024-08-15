cask "affine" do
  arch arm: "arm64", intel: "x64"

  version "0.16.3"
  sha256 arm:   "e415f96f61128a281ef86998979525e4c1687ebe5fd237a82e9260dee791e432",
         intel: "80102a1961e970fbd991e1d15d03e56b691ff746fec48fefb1bf5d712a605b49"

  url "https:github.comtoeverythingAFFiNEreleasesdownloadv#{version}affine-#{version}-stable-macos-#{arch}.zip",
      verified: "github.comtoeverythingAFFiNE"
  name "AFFiNE"
  desc "Note editor and whiteboard"
  homepage "https:affine.pro"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: ">= :catalina"

  app "AFFiNE.app"

  zap trash: [
    "~LibraryApplication SupportAFFiNE",
    "~LibraryLogsAFFiNE",
    "~LibraryPreferencespro.affine.app.plist",
    "~LibrarySaved Application Statepro.affine.app.savedState",
  ]
end