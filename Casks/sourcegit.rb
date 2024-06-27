cask "sourcegit" do
  arch arm: "arm64", intel: "x64"

  version "8.18"
  sha256 arm:   "89a3babf54b61d7eaa6a29fb5a33f9e8e2ddd37fb2bbcad1ebc735a68db3b153",
         intel: "4fd32244bf6f364f705a1a63431d5541b627c81a9809729df7c8b17f985bc41c"

  url "https:github.comsourcegit-scmsourcegitreleasesdownloadv#{version}sourcegit_#{version}.osx-#{arch}.zip"
  name "sourcegit"
  desc "Cross-platform GUI client for GIT users"
  homepage "https:github.comsourcegit-scmsourcegit"

  livecheck do
    strategy :github_releases
  end

  app "SourceGit.app"
end