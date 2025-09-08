cask "sourcegit" do
  arch arm: "arm64", intel: "x64"

  version "2025.33"
  sha256 arm:   "8051b1eab4c59b031698d17f5c0d2de761b6a668e45243153ccc0c59c454bc24",
         intel: "1788d7cb16073026df5e5f566137c623e0487cec2b5680ec4e6bfd53667f9c38"

  url "https://ghfast.top/https://github.com/sourcegit-scm/sourcegit/releases/download/v#{version}/sourcegit_#{version}.osx-#{arch}.zip"
  name "sourcegit"
  desc "Cross-platform GUI client for GIT users"
  homepage "https://github.com/sourcegit-scm/sourcegit"

  livecheck do
    strategy :github_releases
  end

  app "SourceGit.app"
end