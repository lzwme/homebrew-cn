cask "nani" do
  version "1.0.70"
  sha256 "d60252430c0a0d2b49cec02b22ead8bd600415987d6437ab88e7811e5c16b552"

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