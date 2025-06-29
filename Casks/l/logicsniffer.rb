cask "logicsniffer" do
  version "0.9.7.2"
  sha256 "fa38ea4d3a5a6dac2cddd66c860e75e60b6d4162e81e1c32d7adabc17056c99a"

  url "https://lxtreme.nl/ols/ols-#{version}-full.dmg"
  name "Logic Sniffer"
  desc "Software client for the Open Bench Logic Sniffer logic analyser hardware"
  homepage "https://lxtreme.nl/projects/ols/"

  no_autobump! because: :requires_manual_review

  deprecate! date: "2024-09-08", because: :unmaintained

  app "LogicSniffer.app"

  caveats do
    requires_rosetta
  end
end