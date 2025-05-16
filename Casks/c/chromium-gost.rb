cask "chromium-gost" do
  arch arm: "arm64", intel: "amd64"

  version "136.0.7103.114"
  sha256 arm:   "f9433bd4e03071237a9944b9f43f92f400ae1b583a86c36c9cef91c5d95a2ce7",
         intel: "bc7030e31fb7fc5e064252ae934a63249a391c7bfff7ca378c1c688a2b75d3ec"

  url "https:github.comdeemruChromium-Gostreleasesdownload#{version}chromium-gost-#{version}-macos-#{arch}.tar.bz2"
  name "Chromium-Gost"
  desc "Browser based on Chromium with support for GOST cryptographic algorithms"
  homepage "https:github.comdeemruChromium-Gost"

  depends_on macos: ">= :big_sur"

  app "Chromium-Gost.app"

  zap trash: [
    "~LibraryApplication SupportChromium",
    "~LibraryCachesChromium",
  ]
end