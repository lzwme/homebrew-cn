cask "sourcegit" do
  arch arm: "arm64", intel: "x64"

  version "8.29"
  sha256 arm:   "c87bedc555fe3d088934fa21296c787e3066849099de952caa5636fcd1fb598d",
         intel: "1499682e7304c8926504843ef8740e4129747b14c9086c0a6593aec70186026a"

  url "https:github.comsourcegit-scmsourcegitreleasesdownloadv#{version}sourcegit_#{version}.osx-#{arch}.zip"
  name "sourcegit"
  desc "Cross-platform GUI client for GIT users"
  homepage "https:github.comsourcegit-scmsourcegit"

  livecheck do
    strategy :github_releases
  end

  app "SourceGit.app"
end