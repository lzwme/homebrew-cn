cask "affine" do
  arch arm: "arm64", intel: "x64"

  version "0.10.3"
  sha256 arm:   "2c117b0cbc43b5fc972824fdcc1b8940cc458ed99a87df5fa5563df01010224c",
         intel: "29d6efea39150648595850f6a91740f862049e7938e44c80c02767435a9e7093"

  url "https:github.comtoeverythingAFFiNEreleasesdownloadv#{version}affine-stable-macos-#{arch}.zip",
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