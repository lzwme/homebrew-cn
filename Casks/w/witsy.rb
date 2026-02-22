cask "witsy" do
  arch arm: "arm64", intel: "x64"

  version "3.5.1"
  sha256 arm:   "fc13389287a09e17970a24ec72467e926f4001acc65d96af08e53706eadc7e4c",
         intel: "5d90f1a82996bfd9b2001a582d53338c4a41d9c35415444f295503ea11ffee72"

  url "https://ghfast.top/https://github.com/nbonamy/witsy/releases/download/v#{version}/Witsy-#{version}-darwin-#{arch}.dmg",
      verified: "github.com/nbonamy/witsy/"
  name "Witsy"
  desc "BYOK (Bring Your Own Keys) AI assistant"
  homepage "https://witsyai.com/"

  livecheck do
    url "https://update.electronjs.org/nbonamy/witsy/darwin-#{arch}/0.0.0"
    strategy :json do |json|
      json["name"]
    end
  end

  auto_updates true
  depends_on macos: ">= :monterey"

  app "Witsy.app"

  zap trash: [
    "~/Library/Application Support/Witsy",
    "~/Library/Logs/Witsy",
  ]
end