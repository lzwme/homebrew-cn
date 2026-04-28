cask "postman-cli" do
  arch arm: "osx_arm64", intel: "osx64"

  version "1.34.3"
  sha256 arm:   "140c0fcddd9d5fcb8f664a8c5b8ce2efc888cafc21aa798deb1240379f861198",
         intel: "8ed2086731cf365488f01221867f7a6bdd392e563fcabd154b86c7dfe421d47d"

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