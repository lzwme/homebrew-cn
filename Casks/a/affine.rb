cask "affine" do
  arch arm: "arm64", intel: "x64"

  version "0.11.2"
  sha256 arm:   "56160a6a3669b037ed62291fc61764d0134c5985a57102cbde28777cfee1bb04",
         intel: "00b20809070d00f0f71d6bc6ee711b2a3cb8d7d708f020311c42b2aa82860eca"

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