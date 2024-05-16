cask "font-fira-mono-for-powerline" do
  version :latest
  sha256 :no_check

  url "https:github.compowerlinefonts.git",
      branch:    "master",
      only_path: "FiraMono"
  name "Fira Mono for Powerline"
  homepage "https:github.compowerlinefontstreemasterFiraMono"

  font "FuraMono-Bold Powerline.otf"
  font "FuraMono-Medium Powerline.otf"
  font "FuraMono-Regular Powerline.otf"

  # No zap stanza required
end