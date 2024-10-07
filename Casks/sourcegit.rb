cask "sourcegit" do
  arch arm: "arm64", intel: "x64"

  version "8.32"
  sha256 arm:   "cad8a2209a7b791dddc7e382681e1c80f0d1ebc983cbd3cbad3f9e6e7d217494",
         intel: "7d61ffce9ea83e325735e76520313bdca25d810e086269fd21c98e4b57f79598"

  url "https:github.comsourcegit-scmsourcegitreleasesdownloadv#{version}sourcegit_#{version}.osx-#{arch}.zip"
  name "sourcegit"
  desc "Cross-platform GUI client for GIT users"
  homepage "https:github.comsourcegit-scmsourcegit"

  livecheck do
    strategy :github_releases
  end

  app "SourceGit.app"
end