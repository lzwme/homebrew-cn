cask "font-alegreya-sans" do
  version "2.008"
  sha256 "ea545572d49e18e675d6b72a6754da344e24b9cacc3d2b76c1eb2bf9ae73a402"

  url "https:github.comhuertatipograficaAlegreya-Sansarchiverefstagsv#{version}.tar.gz"
  name "Alegreya-Sans"
  homepage "https:github.comhuertatipograficaAlegreya-Sans"

  no_autobump! because: :requires_manual_review

  font "Alegreya-Sans-#{version}fontsotfAlegreyaSans-Black.otf"
  font "Alegreya-Sans-#{version}fontsotfAlegreyaSans-BlackItalic.otf"
  font "Alegreya-Sans-#{version}fontsotfAlegreyaSans-Bold.otf"
  font "Alegreya-Sans-#{version}fontsotfAlegreyaSans-BoldItalic.otf"
  font "Alegreya-Sans-#{version}fontsotfAlegreyaSans-ExtraBold.otf"
  font "Alegreya-Sans-#{version}fontsotfAlegreyaSans-ExtraBoldItalic.otf"
  font "Alegreya-Sans-#{version}fontsotfAlegreyaSans-Italic.otf"
  font "Alegreya-Sans-#{version}fontsotfAlegreyaSans-Light.otf"
  font "Alegreya-Sans-#{version}fontsotfAlegreyaSans-LightItalic.otf"
  font "Alegreya-Sans-#{version}fontsotfAlegreyaSans-Medium.otf"
  font "Alegreya-Sans-#{version}fontsotfAlegreyaSans-MediumItalic.otf"
  font "Alegreya-Sans-#{version}fontsotfAlegreyaSans-Regular.otf"
  font "Alegreya-Sans-#{version}fontsotfAlegreyaSans-Thin.otf"
  font "Alegreya-Sans-#{version}fontsotfAlegreyaSans-ThinItalic.otf"
  font "Alegreya-Sans-#{version}fontsotfAlegreyaSansSC-Black.otf"
  font "Alegreya-Sans-#{version}fontsotfAlegreyaSansSC-BlackItalic.otf"
  font "Alegreya-Sans-#{version}fontsotfAlegreyaSansSC-Bold.otf"
  font "Alegreya-Sans-#{version}fontsotfAlegreyaSansSC-BoldItalic.otf"
  font "Alegreya-Sans-#{version}fontsotfAlegreyaSansSC-ExtraBold.otf"
  font "Alegreya-Sans-#{version}fontsotfAlegreyaSansSC-ExtraBoldItalic.otf"
  font "Alegreya-Sans-#{version}fontsotfAlegreyaSansSC-Italic.otf"
  font "Alegreya-Sans-#{version}fontsotfAlegreyaSansSC-Light.otf"
  font "Alegreya-Sans-#{version}fontsotfAlegreyaSansSC-LightItalic.otf"
  font "Alegreya-Sans-#{version}fontsotfAlegreyaSansSC-Medium.otf"
  font "Alegreya-Sans-#{version}fontsotfAlegreyaSansSC-MediumItalic.otf"
  font "Alegreya-Sans-#{version}fontsotfAlegreyaSansSC-Regular.otf"
  font "Alegreya-Sans-#{version}fontsotfAlegreyaSansSC-Thin.otf"
  font "Alegreya-Sans-#{version}fontsotfAlegreyaSansSC-ThinItalic.otf"

  # No zap stanza required
end