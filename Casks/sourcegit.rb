cask "sourcegit" do
  arch arm: "arm64", intel: "x64"

  version "2025.06"
  sha256 arm:   "650dd01b19ba86dd935fef2eb02f08a36cb25690a9fdbd059fa488a3e096be39",
         intel: "6cd2ac3ca7c4f60ec204d2aba410ac865483ed3fd3c9b906a7bb303f78eb6ea0"

  url "https:github.comsourcegit-scmsourcegitreleasesdownloadv#{version}sourcegit_#{version}.osx-#{arch}.zip"
  name "sourcegit"
  desc "Cross-platform GUI client for GIT users"
  homepage "https:github.comsourcegit-scmsourcegit"

  livecheck do
    strategy :github_releases
  end

  app "SourceGit.app"
end