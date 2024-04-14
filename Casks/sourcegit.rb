cask "sourcegit" do
  arch arm: "arm64", intel: "x64"

  version "8.7"
  sha256 arm:   "f5f11d3c0834a5691a18575008ceee4aa931e2edae10b71f5b38df24135a0638",
         intel: "924b9dc17187a7a632ac3c4fa18ceb26c551680bcc14e878f6297a60136741c9"

  url "https:github.comsourcegit-scmsourcegitreleasesdownloadv#{version}SourceGit.osx-#{arch}.zip"
  name "sourcegit"
  desc "Cross-platform GUI client for GIT users"
  homepage "https:github.comsourcegit-scmsourcegit"

  livecheck do
    strategy :github_releases
  end

  app "SourceGit.app"
end