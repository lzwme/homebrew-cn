cask "font-open-dyslexic" do
  version "20160623-Stable"
  sha256 "3b4a84f573d3f5d75e198bbf362ff6fa812b33d6559dce651e44df455be929cc"

  url "https:codeload.github.comantijingoistopen-dyslexiczip#{version}"
  name "OpenDyslexic"
  homepage "https:github.comantijingoistopen-dyslexic"

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