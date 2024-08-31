cask "sourcegit" do
  arch arm: "arm64", intel: "x64"

  version "8.27"
  sha256 arm:   "9635b47a33d60ab3576260c30cb98d791c090361ff0fa3a0abfe8e5ca65b0567",
         intel: "f28e8a4a2e26cb80ec5c2966522ced2b21b23aeea5adaf2e2e42909b2390fcce"

  url "https:github.comsourcegit-scmsourcegitreleasesdownloadv#{version}sourcegit_#{version}.osx-#{arch}.zip"
  name "sourcegit"
  desc "Cross-platform GUI client for GIT users"
  homepage "https:github.comsourcegit-scmsourcegit"

  livecheck do
    strategy :github_releases
  end

  app "SourceGit.app"
end