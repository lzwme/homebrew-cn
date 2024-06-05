cask "putio-adder" do
  version "3.0.5"
  sha256 "58a772804ea8509e302376838c9ed71f8b3820263843cb65421ec8bfebd5092e"

  url "https:github.comnicoSWDput.io-adderreleasesdownloadv#{version}put.io-adder-v#{version}.zip"
  name "Put.IO Adder"
  homepage "https:github.comnicoSWDput.io-adder"

  deprecate! date: "2024-06-03", because: :unmaintained

  app "put.io adder.app"
end