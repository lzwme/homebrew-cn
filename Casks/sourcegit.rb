cask "sourcegit" do
  arch arm: "arm64", intel: "x64"

  version "2025.39"
  sha256 arm:   "51d273864d51f745804f34b600425b3d6c18da70c59f8f35e39151ca0330a812",
         intel: "4238fb3e35b2c484f6115444608413712e61c91106275918e7ebf5aa6824adfa"

  url "https://ghfast.top/https://github.com/sourcegit-scm/sourcegit/releases/download/v#{version}/sourcegit_#{version}.osx-#{arch}.zip"
  name "SourceGit"
  desc "Cross-platform GUI client for GIT users"
  homepage "https://github.com/sourcegit-scm/sourcegit"

  livecheck do
    strategy :github_releases
  end

  app "SourceGit.app"
  binary "#{appdir}/SourceGit.app/Contents/MacOS/SourceGit", target: "sourcegit"
end