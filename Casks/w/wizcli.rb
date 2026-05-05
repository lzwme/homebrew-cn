cask "wizcli" do
  arch arm: "arm64", intel: "amd64"
  os macos: "darwin", linux: "linux"

  version "1.45.0"
  sha256 arm:          "15da2690f346f012f3f0376dae01b625a4eac1f1031e3469986f5c1917b1db26",
         x86_64:       "d788eb32f16823e360121e0dfb83a8d59bef3e70d0ac7ba975b66954bf23b2be",
         arm64_linux:  "860987c3f6fe30aa37d409142843c61b27243fbc23ca9e0ab55d265ea9731140",
         x86_64_linux: "3f25af9edd63dbd7ecd058b71912f8415467be3f0fcb2b28c6914ebc454d368e"

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