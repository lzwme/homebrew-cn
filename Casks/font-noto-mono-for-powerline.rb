cask "font-noto-mono-for-powerline" do
  version :latest
  sha256 :no_check

  url "https:github.compowerlinefonts.git",
      branch:    "master",
      only_path: "NotoMono"
  name "Noto Mono for Powerline"
  homepage "https:github.compowerlinefontstreemasterNotoMono"

  font "Noto Mono for Powerline.ttf"

  # No zap stanza required
end