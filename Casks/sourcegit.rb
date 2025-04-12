cask "sourcegit" do
  arch arm: "arm64", intel: "x64"

  version "2025.12"
  sha256 arm:   "2152389572ffb45622bf5ccfa2ba3e9443117a868d29c9c836899769cf03f1ad",
         intel: "2d4ad22db13218e9a337134e5bd1b948b97875132e86e3bc3c104dbe14f4cd81"

  url "https:github.comsourcegit-scmsourcegitreleasesdownloadv#{version}sourcegit_#{version}.osx-#{arch}.zip"
  name "sourcegit"
  desc "Cross-platform GUI client for GIT users"
  homepage "https:github.comsourcegit-scmsourcegit"

  livecheck do
    strategy :github_releases
  end

  app "SourceGit.app"
end