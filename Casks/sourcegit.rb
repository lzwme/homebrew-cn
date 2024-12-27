cask "sourcegit" do
  arch arm: "arm64", intel: "x64"

  version "8.44"
  sha256 arm:   "688b7de1ebfa4784146c8edf6a138e0d68fe72c3b660464854504ef85cef4a54",
         intel: "e9b208c7330d074af88e29e7fc8f410c2b20d55f512d5881d0c4b22938a17483"

  url "https:github.comsourcegit-scmsourcegitreleasesdownloadv#{version}sourcegit_#{version}.osx-#{arch}.zip"
  name "sourcegit"
  desc "Cross-platform GUI client for GIT users"
  homepage "https:github.comsourcegit-scmsourcegit"

  livecheck do
    strategy :github_releases
  end

  app "SourceGit.app"
end