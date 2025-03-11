cask "affine" do
  arch arm: "arm64", intel: "x64"

  version "0.20.5"
  sha256 arm:   "affbb4dd3a5711555351b26dbcf93bb9f3c17d1e162fc923ff1dd187195da3b9",
         intel: "27a7fe4ae8b63ade361985679395eea7461657903253230c2e4a9cfe4ef6cef7"

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