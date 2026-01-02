cask "sourcegit" do
  arch arm: "arm64", intel: "x64"

  version "2025.40"
  sha256 arm:   "cb04199770c0c55f660e084b12aec07bc175f901ba2e73ffec628c74c336f08f",
         intel: "15d40c22c023d1c5e63448cafa208596a8442b636f18e7eb600d5e3abdaf635a"

  url "https://ghfast.top/https://github.com/sourcegit-scm/sourcegit/releases/download/v#{version}/sourcegit_#{version}.osx-#{arch}.zip"
  name "SourceGit"
  desc "Cross-platform GUI client for GIT users"
  homepage "https://github.com/sourcegit-scm/sourcegit"

  livecheck do
    strategy :github_releases
  end

  deprecate! date: "2026-01-01", because: "is available in default tap - uninstall then reinstall",
             replacement_cask: "sourcegit"

  depends_on macos: ">= :big_sur"

  app "SourceGit.app"
  binary "#{appdir}/SourceGit.app/Contents/MacOS/SourceGit", target: "sourcegit"
end