cask "sourcegit" do
  arch arm: "arm64", intel: "x64"

  version "8.22.1"
  sha256 arm:   "84e4d5673999cb3f69eba98655d2e5308e45a9d1cfeb8fb7cf9cfe7ae643c17d",
         intel: "6cecbc3410f5d25a4736416229b6e67620b6a39f0ab92e7e81b64f35aac57a28"

  url "https:github.comsourcegit-scmsourcegitreleasesdownloadv#{version}sourcegit_#{version}.osx-#{arch}.zip"
  name "sourcegit"
  desc "Cross-platform GUI client for GIT users"
  homepage "https:github.comsourcegit-scmsourcegit"

  livecheck do
    strategy :github_releases
  end

  app "SourceGit.app"
end