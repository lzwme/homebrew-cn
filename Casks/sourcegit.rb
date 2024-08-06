cask "sourcegit" do
  arch arm: "arm64", intel: "x64"

  version "8.24"
  sha256 arm:   "56b7e7ef1f437be022dcf99508965fe56310946046fbd9a2cbbcd34cb7312b90",
         intel: "3cad6c2e69fa05ad164ae5e68579c350c86ea50a51b6d2f3503d76c047c1ab4c"

  url "https:github.comsourcegit-scmsourcegitreleasesdownloadv#{version}sourcegit_#{version}.osx-#{arch}.zip"
  name "sourcegit"
  desc "Cross-platform GUI client for GIT users"
  homepage "https:github.comsourcegit-scmsourcegit"

  livecheck do
    strategy :github_releases
  end

  app "SourceGit.app"
end