cask "deepstream" do
  version "8.0.0"
  sha256 "6f4bf2be29ab22748c3e71c41a5932ff273db2b98536fd7ddfec2de40b5cccc1"

  url "https:github.comdeepstreamIOdeepstream.ioreleasesdownloadv#{version}deepstream.io-mac-#{version}.pkg",
      verified: "github.comdeepstreamIOdeepstream.io"
  name "deepstream"
  desc "Data-sync realtime server"
  homepage "https:deepstream.io"

  pkg "deepstream.io-mac-#{version}.pkg"

  uninstall pkgutil: "deepstream.io"

  # No zap stanza required

  caveats do
    files_in_usr_local
  end
end