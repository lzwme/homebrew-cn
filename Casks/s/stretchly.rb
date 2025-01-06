cask "stretchly" do
  arch arm: "-arm64"

  version "1.17.1"
  sha256 arm:   "4dc6ff48143f97eeae0db674f9472c74fb0e8af0ecd26429343d99bcb9584241",
         intel: "79e9715634197f459d6d988db08a2c61620aea1ccd3b88d43e296ee61c4914fa"

  url "https:github.comhovancikstretchlyreleasesdownloadv#{version}stretchly-#{version}#{arch}.dmg",
      verified: "github.comhovancikstretchly"
  name "Stretchly"
  desc "Break time reminder app"
  homepage "https:hovancik.netstretchly"

  depends_on macos: ">= :big_sur"

  app "Stretchly.app"

  uninstall quit: "net.hovancik.stretchly"

  zap trash: [
    "~LibraryApplication SupportStretchly",
    "~LibraryLogsStretchly",
    "~LibraryPreferencesnet.hovancik.stretchly.plist",
  ]

  caveats <<~EOS
    This application is not signed. For details see:

    https:github.comhovancikstretchly#application-signing
  EOS
end