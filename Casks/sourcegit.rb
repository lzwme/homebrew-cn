cask "sourcegit" do
  arch arm: "arm64", intel: "x64"

  version "8.13"
  sha256 arm:   "c33e3815b57fcb549ab60eb79b32967431c1198467ef0a8fe6ac08d66a5cbf1c",
         intel: "30cc9cc0c5d594a0f911f1c29bb5c2b8004e81ef63ae2b4f72de263453cbc188"

  url "https:github.comsourcegit-scmsourcegitreleasesdownloadv#{version}sourcegit_#{version}.osx-#{arch}.zip"
  name "sourcegit"
  desc "Cross-platform GUI client for GIT users"
  homepage "https:github.comsourcegit-scmsourcegit"

  livecheck do
    strategy :github_releases
  end

  app "SourceGit.app"
end