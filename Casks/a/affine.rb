cask "affine" do
  arch arm: "arm64", intel: "x64"

  version "0.12.2"
  sha256 arm:   "527d1e4e6085e1ab2925862e52069e474ae29fcbc11c60356837c30d38015a5e",
         intel: "396e1f14a5b0991943a4446ed2ed0c4646a9eb490bf9eaa0c33b907bef6c416c"

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