cask "heptabase" do
  arch arm: "-arm64"

  version "1.92.1"
  sha256 arm:   "1c2649423e99d61968a002a90fd26a32284a41d405d78d655f06643c55148500",
         intel: "95dfc83003932dbf1a98019bd52cef96dd7790423a7d7a7870344744c6be79c6"

  url "https://ghfast.top/https://github.com/heptameta/project-meta/releases/download/v#{version}/Heptabase-#{version}#{arch}-mac.zip",
      verified: "github.com/heptameta/project-meta/"
  name "Hepta"
  desc "Note-taking tool for visual learning"
  homepage "https://heptabase.com/"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: ">= :big_sur"

  app "Heptabase.app"

  zap trash: [
    "~/Library/Preferences/app.projectmeta.projectmeta.plist",
    "~/Library/Saved Application State/app.projectmeta.projectmeta.savedState",
  ]
end