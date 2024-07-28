cask "nimbus" do
  version "0.8.0"
  sha256 "0fec9d878c457a0776deb40a2d3982bdf5aa5de27253ae2a10894520457d9b57"

  url "https:github.comjnordbergirccloudappreleasesdownload#{version}Nimbus.zip"
  name "Nimbus"
  desc "Standalone IRCCloud desktop client"
  homepage "https:github.comjnordbergirccloudapp"

  deprecate! date: "2024-07-27", because: :unmaintained

  app "Nimbus.app"

  caveats do
    requires_rosetta
  end
end