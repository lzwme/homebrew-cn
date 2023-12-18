cask "font-biz-udgothic" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflbizudgothic"
  name "BIZ UDGothic"
  homepage "https:fonts.google.comspecimenBIZ+UDGothic"

  font "BIZUDGothic-Bold.ttf"
  font "BIZUDGothic-Regular.ttf"

  # No zap stanza required
end