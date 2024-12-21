cask "chromium-gost" do
  arch arm: "arm64", intel: "amd64"

  version "131.0.6778.204"
  sha256 arm:   "2721772e793b000871a32020109534c285701043dbd73e0f598e308e78970af1",
         intel: "c89004a570412e27d87dcdb36276774dbe1a4ca9332252bf30eff3dfdbe97213"

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