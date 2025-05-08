cask "sourcegit" do
  arch arm: "arm64", intel: "x64"

  version "2025.16"
  sha256 arm:   "d68b25dfc983d3375e8ca08159442da4dd2ad5249c357fcb753fb014b0d61ba6",
         intel: "cc2af08130b59a58ca04ad036090e49807b76c6c233abec4788f37e13e60e87b"

  url "https:github.comsourcegit-scmsourcegitreleasesdownloadv#{version}sourcegit_#{version}.osx-#{arch}.zip"
  name "sourcegit"
  desc "Cross-platform GUI client for GIT users"
  homepage "https:github.comsourcegit-scmsourcegit"

  livecheck do
    strategy :github_releases
  end

  app "SourceGit.app"
end