cask "putio-adder" do
  version "3.0.5"
  sha256 "0a95a144a2ff43dc8d3bd34229235c6efcc194b20812ce1c1dd2987d709c83a5"

  url "https:github.comnicoSWDput.io-adderreleasesdownloadv#{version}put.io-adder-v#{version}.zip"
  name "Put.IO Adder"
  homepage "https:github.comnicoSWDput.io-adder"

  no_autobump! because: :requires_manual_review

  deprecate! date: "2024-06-03", because: :unmaintained
  disable! date: "2025-06-03", because: :unmaintained

  app "put.io adder.app"
end