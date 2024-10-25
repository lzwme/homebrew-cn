cask "sourcegit" do
  arch arm: "arm64", intel: "x64"

  version "8.35"
  sha256 arm:   "537681adfacc6e0a569edaf9b9f98fc5387dee2d23f77a7d76a592f4142b4aa3",
         intel: "a85f52e2df9fbe3f16c82cead3393e65a8112f52faaed908929cd12014c8bc42"

  url "https:github.comsourcegit-scmsourcegitreleasesdownloadv#{version}sourcegit_#{version}.osx-#{arch}.zip"
  name "sourcegit"
  desc "Cross-platform GUI client for GIT users"
  homepage "https:github.comsourcegit-scmsourcegit"

  livecheck do
    strategy :github_releases
  end

  app "SourceGit.app"
end