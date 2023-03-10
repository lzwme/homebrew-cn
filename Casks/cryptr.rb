cask "cryptr" do
  version "0.5.0"
  sha256 "eb2164ef6fca0df2dc7c61611393e1233d15dce946aa6a09042ff03a8abdf087"

  url "https://ghproxy.com/https://github.com/adobe/cryptr/releases/download/v#{version}/Cryptr-#{version}.dmg"
  name "Cryptr"
  desc "GUI for Hashicorp's Vault"
  homepage "https://github.com/adobe/cryptr"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "Cryptr.app"
end