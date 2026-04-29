cask "heptabase" do
  arch arm: "-arm64"

  version "1.91.3"
  sha256 arm:   "98b1d9a3700a844e23cb34a9e47431767e98115e8bf9275ae66927f9283419c5",
         intel: "2ce3887c27686a63ebc4a9a51372618149d090a459074324069659c4fc8297ba"

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