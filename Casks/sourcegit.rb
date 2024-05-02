cask "sourcegit" do
  arch arm: "arm64", intel: "x64"

  version "8.10"
  sha256 arm:   "01ae1df739ff3437550098e078127cb41544920d82bdf299e1d467c07157481b",
         intel: "ab43430a1d7814a695876fda70740fd24c5397f42ecc20ed234730c999ca1b52"

  url "https:github.comsourcegit-scmsourcegitreleasesdownloadv#{version}sourcegit_#{version}.osx-#{arch}.zip"
  name "sourcegit"
  desc "Cross-platform GUI client for GIT users"
  homepage "https:github.comsourcegit-scmsourcegit"

  livecheck do
    strategy :github_releases
  end

  app "SourceGit.app"
end