cask "postman-cli" do
  arch arm: "osx_arm64", intel: "osx64"

  version "1.34.4"
  sha256 arm:   "aa41d16102d8720d72b3b5c985ebcf2c3cbb5dc0ffdce0d9754e0e2cf48d897f",
         intel: "cf9ff3b99312fcc7cc80d5885e08200d8fb5492272362a2c685f7bd31ce4d88b"

  url "https://dl-cli.pstmn.io/download/version/#{version}/#{arch}",
      verified: "dl-cli.pstmn.io/download/"
  name "Postman CLI"
  desc "CLI for command-line API management on Postman"
  homepage "https://www.postman.com/downloads/"

  livecheck do
    url "https://dl-cli.pstmn.io/api/version/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  auto_updates true
  depends_on :macos

  binary "postman-cli", target: "postman"

  zap trash: "~/.postman"
end