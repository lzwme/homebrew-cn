cask "sourcegit" do
  arch arm: "arm64", intel: "x64"

  version "8.15"
  sha256 arm:   "f0bc664597901f1e0868f86c041b0026a87d33c7b4cca739e804e882147340ed",
         intel: "9dcfb715b7097c11fea752cb0f238b8500b69aff0ee8f6e88feb42206461b15f"

  url "https:github.comsourcegit-scmsourcegitreleasesdownloadv#{version}sourcegit_#{version}.osx-#{arch}.zip"
  name "sourcegit"
  desc "Cross-platform GUI client for GIT users"
  homepage "https:github.comsourcegit-scmsourcegit"

  livecheck do
    strategy :github_releases
  end

  app "SourceGit.app"
end