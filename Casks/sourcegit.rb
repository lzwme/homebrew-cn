cask "sourcegit" do
  arch arm: "arm64", intel: "x64"

  version "8.45"
  sha256 arm:   "a24303f140f2a8babb892fbe8d90799502af6284cbb842ff32786fcded329fd7",
         intel: "f59994f73f454d996ac7a7a6ca37820835fc037cce2db2b84d0d4b956a5dd98f"

  url "https:github.comsourcegit-scmsourcegitreleasesdownloadv#{version}sourcegit_#{version}.osx-#{arch}.zip"
  name "sourcegit"
  desc "Cross-platform GUI client for GIT users"
  homepage "https:github.comsourcegit-scmsourcegit"

  livecheck do
    strategy :github_releases
  end

  app "SourceGit.app"
end