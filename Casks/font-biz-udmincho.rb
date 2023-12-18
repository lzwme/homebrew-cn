cask "font-biz-udmincho" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflbizudmincho"
  name "BIZ UDMincho"
  desc "Universal design typeface in the Japanese Mincho type tradition"
  homepage "https:fonts.google.comspecimenBIZ+UDMincho"

  font "BIZUDMincho-Bold.ttf"
  font "BIZUDMincho-Regular.ttf"

  # No zap stanza required
end