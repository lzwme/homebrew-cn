cask "webarchiveextractor" do
  version "1.1"
  sha256 "6af8a053512de058643462fea10ddc6d7ef729d862eb3552cd6c295e248e9fde"

  url "https://ghfast.top/https://github.com/robrohan/WebArchiveExtractor/releases/download/v#{version}/WebArchiveExtractor.tar.zip",
      verified: "github.com/robrohan/WebArchiveExtractor/"
  name "WebArchiveExtractor"
  desc "Utility to un-archive .webarchive files (like when saving from Safari)"
  homepage "https://robrohan.github.io/WebArchiveExtractor/"

  livecheck do
    skip "Binary releases require payment; source code available for compilation"
  end

  app "WebArchiveExtractor.app"
end