cask "font-anonymice-powerline" do
  version :latest
  sha256 :no_check

  url "https:github.compowerlinefonts.git",
      branch:    "master",
      only_path: "AnonymousPro"
  name "Anonymice Powerline"
  homepage "https:github.compowerlinefontstreemasterAnonymousPro"

  font "Anonymice Powerline Bold Italic.ttf"
  font "Anonymice Powerline Bold.ttf"
  font "Anonymice Powerline Italic.ttf"
  font "Anonymice Powerline.ttf"

  # No zap stanza required
end