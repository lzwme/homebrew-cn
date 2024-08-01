cask "chromium-gost" do
  arch arm: "arm64", intel: "amd64"

  version "127.0.6533.88"
  sha256 arm:   "a90170fac1a4ed7260a2e6badd9827d35cdb7ad7dadad2f7c6c2d04a4062cefa",
         intel: "da18d13c9ad25614977301bf1fb13a6dd5b02ce823d6d112347157fdc17eb908"

  url "https:github.comdeemruChromium-Gostreleasesdownload#{version}chromium-gost-#{version}-macos-#{arch}.tar.bz2"
  name "Chromium-Gost"
  desc "Browser based on Chromium with support for GOST cryptographic algorithms"
  homepage "https:github.comdeemruChromium-Gost"

  depends_on macos: ">= :catalina"

  app "Chromium-Gost.app"

  zap trash: [
    "~LibraryApplication SupportChromium",
    "~LibraryCachesChromium",
  ]
end