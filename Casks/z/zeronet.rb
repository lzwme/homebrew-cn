cask "zeronet" do
  version "0.7.1"
  sha256 :no_check

  url "https:github.comHelloZeroNetZeroNet-distarchiverefsheadsmacZeroNet-dist-mac.tar.gz",
      verified: "github.comHelloZeroNetZeroNet-dist"
  name "ZeroNet"
  desc "Decentralised websites using Bitcoin crypto and BitTorrent network"
  homepage "https:zeronet.io"

  no_autobump! because: :requires_manual_review

  # see https:github.comHelloZeroNetZeroNetissues2847
  deprecate! date: "2024-06-17", because: :unmaintained
  disable! date: "2025-06-17", because: :unmaintained

  app "ZeroNet-dist-macZeroNet.app"

  zap trash: [
    "~LibraryApplication SupportZeroNet",
    "~LibrarySaved Application Stateorg.pythonmac.unspecified.ZeroNet.savedState",
  ]

  caveats do
    requires_rosetta
  end
end