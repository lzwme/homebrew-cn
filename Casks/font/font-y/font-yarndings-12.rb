cask "font-yarndings-12" do
  version :latest
  sha256 :no_check

  url "https://github.com/google/fonts/raw/main/ofl/yarndings12/Yarndings12-Regular.ttf",
      verified: "github.com/google/fonts/"
  name "Yarndings 12"
  homepage "https://fonts.google.com/specimen/Yarndings+12"

  font "Yarndings12-Regular.ttf"

  # No zap stanza required
end