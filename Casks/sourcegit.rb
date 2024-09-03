cask "sourcegit" do
  arch arm: "arm64", intel: "x64"

  version "8.28"
  sha256 arm:   "4c399020ef599a078aa222652310e6563a901b864d4bbbc750f928f1f8c48240",
         intel: "70f55c87478920e787936de0a4f790db4dc2f907abc877f50caa5f1acc23fb70"

  url "https:github.comsourcegit-scmsourcegitreleasesdownloadv#{version}sourcegit_#{version}.osx-#{arch}.zip"
  name "sourcegit"
  desc "Cross-platform GUI client for GIT users"
  homepage "https:github.comsourcegit-scmsourcegit"

  livecheck do
    strategy :github_releases
  end

  app "SourceGit.app"
end