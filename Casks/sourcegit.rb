cask "sourcegit" do
  arch arm: "arm64", intel: "x64"

  version "2025.15"
  sha256 arm:   "5a860bb749274922f5027ec082ebaa88e237645f4550c69a522b324b1d09702d",
         intel: "6ecab70a72bdb2829e12a473a7f635ff7dc2cfa972da834ad3d11f90cc2f3666"

  url "https:github.comsourcegit-scmsourcegitreleasesdownloadv#{version}sourcegit_#{version}.osx-#{arch}.zip"
  name "sourcegit"
  desc "Cross-platform GUI client for GIT users"
  homepage "https:github.comsourcegit-scmsourcegit"

  livecheck do
    strategy :github_releases
  end

  app "SourceGit.app"
end