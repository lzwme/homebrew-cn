cask "akuity" do
  arch arm: "arm64", intel: "amd64"
  os macos: "darwin", linux: "linux"

  version "0.28.1-0.20260226153959-740c121fa509"
  sha256 arm:          "926317b9b5d8beabe8c1106475fbf68bdd814b929a6b5c58653ea18f377cb6a5",
         intel:        "5ffa39faf380e9044944cacf0f9ded6ef5092b719a07283ba008776639035563",
         arm64_linux:  "06339ce4e3fabfcc7601d0fa64c9640a9bfecbb2bff1918a920315a3b96e4f89",
         x86_64_linux: "e10862cbdd989c8d98d626dd87955a7e74e352a03cc3413849ab69ff13a00d45"

  url "https://dl.akuity.io/akuity-cli/v#{version}/#{os}/#{arch}/akuity"
  name "Akuity"
  desc "Management tool for the Akuity Platform"
  homepage "https://akuity.io/"

  livecheck do
    url "https://dl.akuity.io/akuity-cli/stable.txt"
    regex(/v?(\d+(?:\.\d+)+(?:[_-]\d+(?:\.\d+)*)?(?:[_-]\h+)?)/i)
  end

  binary "akuity"

  zap trash: "~/.config/akuity"
end