cask "sourcegit" do
  arch arm: "arm64", intel: "x64"

  version "8.17"
  sha256 arm:   "1067cbff769c0a7bd812957687c406af12e616fefde985385319b6a9d03f00a6",
         intel: "c16d79468f6b19813feeb934497b0b3dffb671342fa42c76fdcff8601adac65e"

  url "https:github.comsourcegit-scmsourcegitreleasesdownloadv#{version}sourcegit_#{version}.osx-#{arch}.zip"
  name "sourcegit"
  desc "Cross-platform GUI client for GIT users"
  homepage "https:github.comsourcegit-scmsourcegit"

  livecheck do
    strategy :github_releases
  end

  app "SourceGit.app"
end