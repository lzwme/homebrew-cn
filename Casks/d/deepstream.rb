cask "deepstream" do
  version "7.0.10"
  sha256 "3e82240b08ef33eae93a6f94d19af959a4664dac5d2589f057fb1f7b9a5d3e72"

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