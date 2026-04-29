cask "tuist" do
  version "4.190.0"
  sha256 "861786d539abfd1ceecd8a795422de45fccd8fe9639c3591b3141650acc476ab"

  url "https://ghfast.top/https://github.com/tuist/tuist/releases/download/#{version}/tuist.zip",
      verified: "github.com/tuist/tuist/"
  name "Tuist"
  desc "Create, maintain, and interact with Xcode projects at scale"
  homepage "https://tuist.io/"

  depends_on :macos

  binary "tuist"

  zap trash: "~/.tuist"
end