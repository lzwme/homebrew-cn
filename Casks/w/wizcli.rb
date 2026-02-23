cask "wizcli" do
  arch arm: "arm64", intel: "amd64"
  os macos: "darwin", linux: "linux"

  version "1.32.0"
  sha256 arm:          "705a170fd9e53c5bb52a33ae2154c62b63fa1db0be42c2acd393e7728774d0c1",
         x86_64:       "bd92e97c4360f3afa2a34919bffda2aad1398ed0c6cac9b8abd3924db61563dc",
         arm64_linux:  "fbcab59161990a483ffb1536df4d8981ac53b3f369de5d44e40e2d16a47de752",
         x86_64_linux: "718abc845fb0b6794ea7f1852b3ed2c346145737142d4abb011a7334100f76a1"

  url "https://downloads.wiz.io/v#{version.major}/wizcli/#{version}/wizcli-#{os}-#{arch}"
  name "Wiz CLI"
  desc "CLI for interacting with the Wiz platform"
  homepage "https://www.wiz.io/"

  livecheck do
    url "https://downloads.wiz.io/v#{version.major}/wizcli/latest/wizcli-version"
    regex(/cli:\s"(\d+(?:\.\d+)+)/i)
  end

  binary "wizcli-#{os}-#{arch}", target: "wizcli"

  zap trash: "~/.wiz"
end