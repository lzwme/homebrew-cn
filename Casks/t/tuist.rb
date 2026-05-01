cask "tuist" do
  version "4.191.4"
  sha256 "b915b32750a02063d7b9722e94b7d2291afb73592b2eaa1d17bb46c4ac363196"

  url "https://ghfast.top/https://github.com/tuist/tuist/releases/download/#{version}/tuist.zip",
      verified: "github.com/tuist/tuist/"
  name "Tuist"
  desc "Create, maintain, and interact with Xcode projects at scale"
  homepage "https://tuist.io/"

  depends_on :macos

  binary "tuist"

  zap trash: "~/.tuist"
end