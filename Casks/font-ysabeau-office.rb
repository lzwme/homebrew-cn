cask "font-ysabeau-office" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflysabeauoffice"
  name "Ysabeau Office"
  desc "Exercise in restraint"
  homepage "https:fonts.google.comspecimenYsabeau+Office"

  font "YsabeauOffice-Italic[wght].ttf"
  font "YsabeauOffice[wght].ttf"

  # No zap stanza required
end