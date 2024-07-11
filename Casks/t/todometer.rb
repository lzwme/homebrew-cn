cask "todometer" do
  version "2.0.1"
  sha256 "b8de5c09dc1d5d026130555f3cc85c949ddd7bd0cbf63a45bd1d4c2aba6cbf31"

  url "https:github.comcassidootodometerreleasesdownloadv#{version}todometer.for.mac.zip",
      verified: "github.comcassidootodometer"
  name "todometer"
  desc "Meter-based to-do list"
  homepage "https:cassidoo.github.iotodometer"

  app "mactodometer.app"

  zap trash: [
    "~LibraryApplication Supporttodometer",
    "~LibraryPreferencescom.electron.todometer.plist",
  ]

  caveats do
    requires_rosetta
  end
end