cask "sourcegit" do
  arch arm: "arm64", intel: "x64"

  version "8.14"
  sha256 arm:   "a534cf494ea2a2eb308c555b44e51b14759bad37a7eac509dcfdf4dec6978516",
         intel: "949df2f1577fb87776dbc12ccdc4e9e5bb1648ef26782159b30c49c9456033ae"

  url "https:github.comsourcegit-scmsourcegitreleasesdownloadv#{version}sourcegit_#{version}.osx-#{arch}.zip"
  name "sourcegit"
  desc "Cross-platform GUI client for GIT users"
  homepage "https:github.comsourcegit-scmsourcegit"

  livecheck do
    strategy :github_releases
  end

  app "SourceGit.app"
end