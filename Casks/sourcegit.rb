cask "sourcegit" do
  arch arm: "arm64", intel: "x64"

  version "2025.25"
  sha256 arm:   "e68689b7ede532cd443c637cc7e8324030098fe58b21eded9609840b8883f7b9",
         intel: "78a32c9f3932ea0d6fec62e35fbc884e9dfc6d2aa6ed64a8ace535e62cad5870"

  url "https://ghfast.top/https://github.com/sourcegit-scm/sourcegit/releases/download/v#{version}/sourcegit_#{version}.osx-#{arch}.zip"
  name "sourcegit"
  desc "Cross-platform GUI client for GIT users"
  homepage "https://github.com/sourcegit-scm/sourcegit"

  livecheck do
    strategy :github_releases
  end

  app "SourceGit.app"
end