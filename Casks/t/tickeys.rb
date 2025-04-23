cask "tickeys" do
  version "0.5.0"
  sha256 "55e4550ced3f1bed413e15229e813443019f335f546b1edd41418744eee8e325"

  url "https:github.comyingDevTickeysreleasesdownload#{version}Tickeys-#{version}-yosemite.dmg",
      verified: "github.comyingDevTickeys"
  name "Tickeys"
  desc "Utility for producing audio feedback when typing"
  homepage "https:www.yingdev.comprojectstickeys"

  deprecate! date: "2025-04-21", because: :unmaintained

  app "Tickeys.app"

  zap trash: "~LibraryPreferencescom.yingDev.Tickeys.plist"

  caveats do
    requires_rosetta
  end
end