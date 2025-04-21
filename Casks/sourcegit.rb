cask "sourcegit" do
  arch arm: "arm64", intel: "x64"

  version "2025.13"
  sha256 arm:   "b5adadacfc9017d83fd4d0b2304c6c91fec36187abd2be658e82c460d6906651",
         intel: "a439e75f97c10f672e1821caf1f0d52c8e82b06b50dd0031239c3765181f89a4"

  url "https:github.comsourcegit-scmsourcegitreleasesdownloadv#{version}sourcegit_#{version}.osx-#{arch}.zip"
  name "sourcegit"
  desc "Cross-platform GUI client for GIT users"
  homepage "https:github.comsourcegit-scmsourcegit"

  livecheck do
    strategy :github_releases
  end

  app "SourceGit.app"
end