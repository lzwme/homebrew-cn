cask "sourcegit" do
  arch arm: "arm64", intel: "x64"

  version "2025.27"
  sha256 arm:   "b3017934c790b409be51667505546c810fdabb582162dd7b4bf8ef5a3f32e539",
         intel: "f3eda69e92d60299404f5c33b7deba665099aa028802eac020cf26581d3024e2"

  url "https://ghfast.top/https://github.com/sourcegit-scm/sourcegit/releases/download/v#{version}/sourcegit_#{version}.osx-#{arch}.zip"
  name "sourcegit"
  desc "Cross-platform GUI client for GIT users"
  homepage "https://github.com/sourcegit-scm/sourcegit"

  livecheck do
    strategy :github_releases
  end

  app "SourceGit.app"
end