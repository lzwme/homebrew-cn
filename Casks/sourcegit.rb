cask "sourcegit" do
  arch arm: "arm64", intel: "x64"

  version "8.43"
  sha256 arm:   "4b698f7913e96a7e4bd29b172c74be0f81bf8945f65ef47aa99a4c4a87f0d808",
         intel: "a46fec9290e94f91384e5159be784d45f691900bd8ab13f518e8d62164dfbe11"

  url "https:github.comsourcegit-scmsourcegitreleasesdownloadv#{version}sourcegit_#{version}.osx-#{arch}.zip"
  name "sourcegit"
  desc "Cross-platform GUI client for GIT users"
  homepage "https:github.comsourcegit-scmsourcegit"

  livecheck do
    strategy :github_releases
  end

  app "SourceGit.app"
end