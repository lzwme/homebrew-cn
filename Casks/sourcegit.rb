cask "sourcegit" do
  arch arm: "arm64", intel: "x64"

  version "8.8"
  sha256 arm:   "fd3b8f5de0d76bf122f12a911c7eeb403143334c0b84ac001ffac70b48b48cb9",
         intel: "dc5f1674d63a213584258c8330713f89cdd5901afd3711d90c2f5ec8735d7972"

  url "https:github.comsourcegit-scmsourcegitreleasesdownloadv#{version}SourceGit.osx-#{arch}.zip"
  name "sourcegit"
  desc "Cross-platform GUI client for GIT users"
  homepage "https:github.comsourcegit-scmsourcegit"

  livecheck do
    strategy :github_releases
  end

  app "SourceGit.app"
end