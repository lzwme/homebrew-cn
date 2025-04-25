cask "sourcegit" do
  arch arm: "arm64", intel: "x64"

  version "2025.14"
  sha256 arm:   "a5c2c0b41d5307dc06342ba93b66e736731b47295f6701608b6c410e8c7f7b8f",
         intel: "1b06cfecf6a26400c6e9c24351b06e9066648e7e728ce5964591418ca45894d4"

  url "https:github.comsourcegit-scmsourcegitreleasesdownloadv#{version}sourcegit_#{version}.osx-#{arch}.zip"
  name "sourcegit"
  desc "Cross-platform GUI client for GIT users"
  homepage "https:github.comsourcegit-scmsourcegit"

  livecheck do
    strategy :github_releases
  end

  app "SourceGit.app"
end