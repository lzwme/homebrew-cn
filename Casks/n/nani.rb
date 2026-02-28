cask "nani" do
  version "1.0.68"
  sha256 "45fc84e1f1bc4b25977ddb716190a652526958d8ee311220170493025344edad"

  url "https://nani-desktop.kiok.jp/artifacts/nani-#{version}.dmg",
      verified: "nani-desktop.kiok.jp/artifacts/"
  name "Nani Translate"
  desc "AI-powered translator"
  homepage "https://nani.now/"

  livecheck do
    url "https://nani-desktop.kiok.jp/artifacts/latest-mac.yml"
    strategy :electron_builder
  end

  auto_updates true
  depends_on macos: ">= :monterey"

  app "Nani.app"

  zap trash: "~/Library/Application Support/Nani"
end