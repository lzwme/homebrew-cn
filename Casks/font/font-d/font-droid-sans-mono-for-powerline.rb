cask "font-droid-sans-mono-for-powerline" do
  version :latest
  sha256 :no_check

  url "https:github.compowerlinefonts.git",
      branch:    "master",
      only_path: "DroidSansMono"
  name "Droid Sans Mono for Powerline"
  homepage "https:github.compowerlinefontstreemasterDroidSansMono"

  font "Droid Sans Mono for Powerline.otf"

  # No zap stanza required
end