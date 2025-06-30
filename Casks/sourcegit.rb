cask "sourcegit" do
  arch arm: "arm64", intel: "x64"

  version "2025.23"
  sha256 arm:   "6d2134246619eaee81b943ec9de5708b1caa506af407acde8450c61869360fb4",
         intel: "f26eed856217c49650c6ea6a95627943fe5b15cc63500032c6ccc64cbc69c824"

  url "https:github.comsourcegit-scmsourcegitreleasesdownloadv#{version}sourcegit_#{version}.osx-#{arch}.zip"
  name "sourcegit"
  desc "Cross-platform GUI client for GIT users"
  homepage "https:github.comsourcegit-scmsourcegit"

  livecheck do
    strategy :github_releases
  end

  app "SourceGit.app"
end