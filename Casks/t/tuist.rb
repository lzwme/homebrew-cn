cask "tuist" do
  version "4.152.0"
  sha256 "bb5b8474d73ca97e2ffc2f6437bd93d75fe839be282fe8360b5568c50333799d"

  url "https://ghfast.top/https://github.com/tuist/tuist/releases/download/#{version}/tuist.zip",
      verified: "github.com/tuist/tuist/"
  name "Tuist"
  desc "Create, maintain, and interact with Xcode projects at scale"
  homepage "https://tuist.io/"

  binary "tuist"

  zap trash: "~/.tuist"
end