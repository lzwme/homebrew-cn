cask "font-inconsolata-g-for-powerline" do
  version :latest
  sha256 :no_check

  url "https:github.compowerlinefonts.git",
      branch:    "master",
      only_path: "Inconsolata-g"
  name "Inconsolata-g for Powerline"
  homepage "https:github.compowerlinefontstreemasterInconsolata-g"

  font "Inconsolata-g for Powerline.otf"

  # No zap stanza required
end