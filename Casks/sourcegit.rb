cask "sourcegit" do
  arch arm: "arm64", intel: "x64"

  version "2025.09"
  sha256 arm:   "d3db0fcd70514dbacceb616aa86d95667bbbd6d91eab0eea2ba58a4b5df66264",
         intel: "aedd1b424dfb2c24e85f5132fb656ff9ec53b853e9ffb7971e8680bdb031fca9"

  url "https:github.comsourcegit-scmsourcegitreleasesdownloadv#{version}sourcegit_#{version}.osx-#{arch}.zip"
  name "sourcegit"
  desc "Cross-platform GUI client for GIT users"
  homepage "https:github.comsourcegit-scmsourcegit"

  livecheck do
    strategy :github_releases
  end

  app "SourceGit.app"
end