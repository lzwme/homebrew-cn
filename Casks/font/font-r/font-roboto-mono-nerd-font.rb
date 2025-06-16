cask "font-roboto-mono-nerd-font" do
  version "3.4.0"
  sha256 "84a4e9d0bc8b5f55c0476d82ab73f36315a16171a4d06bf5270fd604c7103c9f"

  url "https:github.comryanoasisnerd-fontsreleasesdownloadv#{version}RobotoMono.zip"
  name "RobotoMono Nerd Font (Roboto Mono)"
  homepage "https:github.comryanoasisnerd-fonts"

  no_autobump! because: :bumped_by_upstream

  livecheck do
    url :url
    strategy :github_latest
  end

  font "RobotoMonoNerdFont-Bold.ttf"
  font "RobotoMonoNerdFont-BoldItalic.ttf"
  font "RobotoMonoNerdFont-Italic.ttf"
  font "RobotoMonoNerdFont-Light.ttf"
  font "RobotoMonoNerdFont-LightItalic.ttf"
  font "RobotoMonoNerdFont-Medium.ttf"
  font "RobotoMonoNerdFont-MediumItalic.ttf"
  font "RobotoMonoNerdFont-Regular.ttf"
  font "RobotoMonoNerdFont-SemiBold.ttf"
  font "RobotoMonoNerdFont-SemiBoldItalic.ttf"
  font "RobotoMonoNerdFont-Thin.ttf"
  font "RobotoMonoNerdFont-ThinItalic.ttf"
  font "RobotoMonoNerdFontMono-Bold.ttf"
  font "RobotoMonoNerdFontMono-BoldItalic.ttf"
  font "RobotoMonoNerdFontMono-Italic.ttf"
  font "RobotoMonoNerdFontMono-Light.ttf"
  font "RobotoMonoNerdFontMono-LightItalic.ttf"
  font "RobotoMonoNerdFontMono-Medium.ttf"
  font "RobotoMonoNerdFontMono-MediumItalic.ttf"
  font "RobotoMonoNerdFontMono-Regular.ttf"
  font "RobotoMonoNerdFontMono-SemiBold.ttf"
  font "RobotoMonoNerdFontMono-SemiBoldItalic.ttf"
  font "RobotoMonoNerdFontMono-Thin.ttf"
  font "RobotoMonoNerdFontMono-ThinItalic.ttf"
  font "RobotoMonoNerdFontPropo-Bold.ttf"
  font "RobotoMonoNerdFontPropo-BoldItalic.ttf"
  font "RobotoMonoNerdFontPropo-Italic.ttf"
  font "RobotoMonoNerdFontPropo-Light.ttf"
  font "RobotoMonoNerdFontPropo-LightItalic.ttf"
  font "RobotoMonoNerdFontPropo-Medium.ttf"
  font "RobotoMonoNerdFontPropo-MediumItalic.ttf"
  font "RobotoMonoNerdFontPropo-Regular.ttf"
  font "RobotoMonoNerdFontPropo-SemiBold.ttf"
  font "RobotoMonoNerdFontPropo-SemiBoldItalic.ttf"
  font "RobotoMonoNerdFontPropo-Thin.ttf"
  font "RobotoMonoNerdFontPropo-ThinItalic.ttf"

  # No zap stanza required
end