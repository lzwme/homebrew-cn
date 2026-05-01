cask "postman-cli" do
  arch arm: "osx_arm64", intel: "osx64"

  version "1.34.5"
  sha256 arm:   "7cb9d7b46b176a9318c50f8d64432164261aa9931eddcceae61728f686d12eba",
         intel: "2252df4170bc433cf347d41d3420c309330141b0ab7444b1c54f5a7d116252b1"

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