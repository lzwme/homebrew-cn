cask "affine" do
  arch arm: "arm64", intel: "x64"

  version "0.12.1"
  sha256 arm:   "3692b340664fa27fdaac34e04860798ab5880d5e069e8ca476f6492e3b46f63a",
         intel: "e4111cbc264de54814370d332a2dc7c8b9a93e7055e48ef5f3d7077a781c19a3"

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