cask "font-comic-relief" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      branch:    "main",
      only_path: "oflcomicrelief"
  name "Comic Relief"
  homepage "https:github.comloudifierComic-Relief"

  font "ComicRelief-Bold.ttf"
  font "ComicRelief-Regular.ttf"

  # No zap stanza required
end