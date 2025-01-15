cask "sourcegit" do
  arch arm: "arm64", intel: "x64"

  version "2025.02"
  sha256 arm:   "264bed016897e18076df5e3243260d103f056551e7c35671eaf4289c844686e2",
         intel: "7b42746ea366d1e11bf57a6c74a978e8e7b7567f9b8a6601c12a75448619b5fb"

  url "https:github.comsourcegit-scmsourcegitreleasesdownloadv#{version}sourcegit_#{version}.osx-#{arch}.zip"
  name "sourcegit"
  desc "Cross-platform GUI client for GIT users"
  homepage "https:github.comsourcegit-scmsourcegit"

  livecheck do
    strategy :github_releases
  end

  app "SourceGit.app"
end