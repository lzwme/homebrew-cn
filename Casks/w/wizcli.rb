cask "wizcli" do
  arch arm: "arm64", intel: "amd64"
  os macos: "darwin", linux: "linux"

  version "1.44.0"
  sha256 arm:          "1691a0fc8392c32a3824bf169697d55ad60596621b5c5744c9e69492491d5fac",
         x86_64:       "f53a29c52dc8af5ffbda92b25fb28b6c272cf843770d7258c7129375a5b43873",
         arm64_linux:  "443ac1747c7cc8f0d03a6be7eb742dbf9a93ba7e8412d74cbacefedbc96f7d31",
         x86_64_linux: "8f268b9d579a45c1d08b79b2a25315d7dbe47f1914e8a834f49adbd91c689db5"

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