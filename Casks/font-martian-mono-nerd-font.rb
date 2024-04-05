cask "font-martian-mono-nerd-font" do
  version "3.2.0"
  sha256 "4990d8db81d7324a4e5eb27bde37b24e3d3fcf91edecf5c25366059d29345c24"

  url "https:github.comryanoasisnerd-fontsreleasesdownloadv#{version}MartianMono.zip"
  name "MartianMono Nerd Font (MartianMono)"
  desc "Developer targeted fonts with a high number of glyphs"
  homepage "https:github.comryanoasisnerd-fonts"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "MartianMonoNerdFont-Bold.ttf"
  font "MartianMonoNerdFont-CondensedBold.ttf"
  font "MartianMonoNerdFont-CondensedMedium.ttf"
  font "MartianMonoNerdFont-CondensedRegular.ttf"
  font "MartianMonoNerdFont-Medium.ttf"
  font "MartianMonoNerdFont-Regular.ttf"
  font "MartianMonoNerdFontMono-Bold.ttf"
  font "MartianMonoNerdFontMono-CondensedBold.ttf"
  font "MartianMonoNerdFontMono-CondensedMedium.ttf"
  font "MartianMonoNerdFontMono-CondensedRegular.ttf"
  font "MartianMonoNerdFontMono-Medium.ttf"
  font "MartianMonoNerdFontMono-Regular.ttf"
  font "MartianMonoNerdFontPropo-Bold.ttf"
  font "MartianMonoNerdFontPropo-CondensedBold.ttf"
  font "MartianMonoNerdFontPropo-CondensedMedium.ttf"
  font "MartianMonoNerdFontPropo-CondensedRegular.ttf"
  font "MartianMonoNerdFontPropo-Medium.ttf"
  font "MartianMonoNerdFontPropo-Regular.ttf"

  # No zap stanza required
end