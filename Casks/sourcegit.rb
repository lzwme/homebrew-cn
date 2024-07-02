cask "sourcegit" do
  arch arm: "arm64", intel: "x64"

  version "8.19"
  sha256 arm:   "c9ac46df57b0ca5934c0e42038052e8da49d67340723dd1321398ea701f07856",
         intel: "d9a15c8b05282f27ebe921f1da30bced35d7bdbd25f13549390fc7ba40ebb26c"

  url "https:github.comsourcegit-scmsourcegitreleasesdownloadv#{version}sourcegit_#{version}.osx-#{arch}.zip"
  name "sourcegit"
  desc "Cross-platform GUI client for GIT users"
  homepage "https:github.comsourcegit-scmsourcegit"

  livecheck do
    strategy :github_releases
  end

  app "SourceGit.app"
end