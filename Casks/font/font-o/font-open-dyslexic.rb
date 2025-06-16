cask "font-open-dyslexic" do
  version "20160623-Stable"
  sha256 "a44fde7d5fcf1e3825d00de20f7d71fb7b339a7e71067cd9566e8ab16692802a"

  url "https:github.comantijingoistopen-dyslexicarchiverefstags#{version}.tar.gz"
  name "OpenDyslexic"
  homepage "https:github.comantijingoistopen-dyslexic"

  no_autobump! because: :requires_manual_review

  font "open-dyslexic-#{version}otfOpenDyslexic-Bold.otf"
  font "open-dyslexic-#{version}otfOpenDyslexic-BoldItalic.otf"
  font "open-dyslexic-#{version}otfOpenDyslexic-Italic.otf"
  font "open-dyslexic-#{version}otfOpenDyslexic-Regular.otf"
  font "open-dyslexic-#{version}otfOpenDyslexicAlta-Bold.otf"
  font "open-dyslexic-#{version}otfOpenDyslexicAlta-BoldItalic.otf"
  font "open-dyslexic-#{version}otfOpenDyslexicAlta-Italic.otf"
  font "open-dyslexic-#{version}otfOpenDyslexicAlta-Regular.otf"
  font "open-dyslexic-#{version}otfOpenDyslexicMono-Regular.otf"

  # No zap stanza required
end