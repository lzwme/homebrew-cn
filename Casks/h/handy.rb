cask "handy" do
  arch arm: "aarch64", intel: "x64"

  version "0.7.8"
  sha256 arm:   "a35e57fc2e052a7ef9f727c93ccf1ae155fe89a3275dff669a6372ccda55278b",
         intel: "6d3fee09047ee9b9c3818976daf7ba7176d7a132012a2b5d860e2e8b395895b0"

  url "https://ghfast.top/https://github.com/cjpais/Handy/releases/download/v#{version}/Handy_#{version}_#{arch}.dmg",
      verified: "github.com/cjpais/Handy/"
  name "Handy"
  desc "Speech to text application"
  homepage "https://handy.computer/"

  depends_on macos: ">= :ventura"

  app "Handy.app"

  zap trash: [
    "~/Library/Application Support/com.pais.handy",
    "~/Library/Caches/com.pais.handy",
    "~/Library/LaunchAgents/Handy.plist",
    "~/Library/WebKit/com.pais.handy",
  ]
end