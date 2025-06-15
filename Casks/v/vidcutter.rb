cask "vidcutter" do
  version "6.0.5.1"
  sha256 "8d1556887f0b203ebcb7b6e13a33389afad173a2c73dbc906b69ece034218f02"

  url "https:github.comozmartianvidcutterreleasesdownload#{version}VidCutter-#{version}-macOS.dmg"
  name "VidCutter"
  desc "Media cutter and joiner"
  homepage "https:github.comozmartianvidcutter"

  livecheck do
    url :url
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  app "VidCutter.app"

  caveats do
    requires_rosetta
  end
end