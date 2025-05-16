cask "sourcegit" do
  arch arm: "arm64", intel: "x64"

  version "2025.17"
  sha256 arm:   "d4f2de1ecb459c9b20713da184825732aef666276395a09101037208fe373ece",
         intel: "bdc9deac152e6fc1a7135ba9df662244c07cf8471824d88cd660094e4bb6d5d9"

  url "https:github.comsourcegit-scmsourcegitreleasesdownloadv#{version}sourcegit_#{version}.osx-#{arch}.zip"
  name "sourcegit"
  desc "Cross-platform GUI client for GIT users"
  homepage "https:github.comsourcegit-scmsourcegit"

  livecheck do
    strategy :github_releases
  end

  app "SourceGit.app"
end