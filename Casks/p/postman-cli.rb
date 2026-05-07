cask "postman-cli" do
  arch arm: "osx_arm64", intel: "osx64"

  version "1.35.1"
  sha256 arm:   "b8fbae41c5568e76dca7c7ed52cc525b0bc2b9133a06723236416b58680d1f13",
         intel: "477ce699db7b19767e999816bbcb7e23e869e6a36cdca6e7a6a05d9b432656d7"

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