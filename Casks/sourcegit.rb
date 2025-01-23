cask "sourcegit" do
  arch arm: "arm64", intel: "x64"

  version "2025.03"
  sha256 arm:   "098c3a0159e2eab0dd6b34448139242c889cbe5343820a62fb0a14cb071864c0",
         intel: "43f04fca605920822e92e985b29ee2af560c52a8a0760dd96408deccfda8487c"

  url "https:github.comsourcegit-scmsourcegitreleasesdownloadv#{version}sourcegit_#{version}.osx-#{arch}.zip"
  name "sourcegit"
  desc "Cross-platform GUI client for GIT users"
  homepage "https:github.comsourcegit-scmsourcegit"

  livecheck do
    strategy :github_releases
  end

  app "SourceGit.app"
end