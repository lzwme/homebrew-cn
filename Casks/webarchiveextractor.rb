cask "webarchiveextractor" do
  version "1.1"
  url "https://ghproxy.com/https://github.com/robrohan/WebArchiveExtractor/releases/download/v#{version}/WebArchiveExtractor.tar.zip"
  sha256 "6af8a053512de058643462fea10ddc6d7ef729d862eb3552cd6c295e248e9fde"
  name "WebArchiveExtractor"
  desc "utility to un-archive .webarchive files (like when saving from Safari)"
  homepage "http://robrohan.github.io/WebArchiveExtractor/"

  app "WebArchiveExtractor.app"
end