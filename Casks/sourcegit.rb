cask "sourcegit" do
  arch arm: "arm64", intel: "x64"

  version "8.34"
  sha256 arm:   "31ac3082355e394a0741466e11bf35847a0b59d99277070e97216d82755dc0bc",
         intel: "d9c4a57c991c5dcca50e73b03b6806376de65f6deb98d6d8cc991d17f83af342"

  url "https:github.comsourcegit-scmsourcegitreleasesdownloadv#{version}sourcegit_#{version}.osx-#{arch}.zip"
  name "sourcegit"
  desc "Cross-platform GUI client for GIT users"
  homepage "https:github.comsourcegit-scmsourcegit"

  livecheck do
    strategy :github_releases
  end

  app "SourceGit.app"
end