cask "sourcegit" do
  arch arm: "arm64", intel: "x64"

  version "8.31"
  sha256 arm:   "1f27e679fa5cd6ce4f8c7a98a91ef3879ad3f6a6d85f3f481a2cf12d9245efa2",
         intel: "b37dc6bb990092ac7c07de62db3bb5e20c68a4258d6cf4148bb0f99aea15297e"

  url "https:github.comsourcegit-scmsourcegitreleasesdownloadv#{version}sourcegit_#{version}.osx-#{arch}.zip"
  name "sourcegit"
  desc "Cross-platform GUI client for GIT users"
  homepage "https:github.comsourcegit-scmsourcegit"

  livecheck do
    strategy :github_releases
  end

  app "SourceGit.app"
end