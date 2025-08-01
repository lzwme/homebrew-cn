cask "font-alegreya-sans" do
  version "2.008"
  sha256 "ea545572d49e18e675d6b72a6754da344e24b9cacc3d2b76c1eb2bf9ae73a402"

  url "https://ghfast.top/https://github.com/huertatipografica/Alegreya-Sans/archive/refs/tags/v#{version}.tar.gz"
  name "Alegreya-Sans"
  homepage "https://github.com/huertatipografica/Alegreya-Sans"

  no_autobump! because: :requires_manual_review

  font "Alegreya-Sans-#{version}/fonts/otf/AlegreyaSans-Black.otf"
  font "Alegreya-Sans-#{version}/fonts/otf/AlegreyaSans-BlackItalic.otf"
  font "Alegreya-Sans-#{version}/fonts/otf/AlegreyaSans-Bold.otf"
  font "Alegreya-Sans-#{version}/fonts/otf/AlegreyaSans-BoldItalic.otf"
  font "Alegreya-Sans-#{version}/fonts/otf/AlegreyaSans-ExtraBold.otf"
  font "Alegreya-Sans-#{version}/fonts/otf/AlegreyaSans-ExtraBoldItalic.otf"
  font "Alegreya-Sans-#{version}/fonts/otf/AlegreyaSans-Italic.otf"
  font "Alegreya-Sans-#{version}/fonts/otf/AlegreyaSans-Light.otf"
  font "Alegreya-Sans-#{version}/fonts/otf/AlegreyaSans-LightItalic.otf"
  font "Alegreya-Sans-#{version}/fonts/otf/AlegreyaSans-Medium.otf"
  font "Alegreya-Sans-#{version}/fonts/otf/AlegreyaSans-MediumItalic.otf"
  font "Alegreya-Sans-#{version}/fonts/otf/AlegreyaSans-Regular.otf"
  font "Alegreya-Sans-#{version}/fonts/otf/AlegreyaSans-Thin.otf"
  font "Alegreya-Sans-#{version}/fonts/otf/AlegreyaSans-ThinItalic.otf"
  font "Alegreya-Sans-#{version}/fonts/otf/AlegreyaSansSC-Black.otf"
  font "Alegreya-Sans-#{version}/fonts/otf/AlegreyaSansSC-BlackItalic.otf"
  font "Alegreya-Sans-#{version}/fonts/otf/AlegreyaSansSC-Bold.otf"
  font "Alegreya-Sans-#{version}/fonts/otf/AlegreyaSansSC-BoldItalic.otf"
  font "Alegreya-Sans-#{version}/fonts/otf/AlegreyaSansSC-ExtraBold.otf"
  font "Alegreya-Sans-#{version}/fonts/otf/AlegreyaSansSC-ExtraBoldItalic.otf"
  font "Alegreya-Sans-#{version}/fonts/otf/AlegreyaSansSC-Italic.otf"
  font "Alegreya-Sans-#{version}/fonts/otf/AlegreyaSansSC-Light.otf"
  font "Alegreya-Sans-#{version}/fonts/otf/AlegreyaSansSC-LightItalic.otf"
  font "Alegreya-Sans-#{version}/fonts/otf/AlegreyaSansSC-Medium.otf"
  font "Alegreya-Sans-#{version}/fonts/otf/AlegreyaSansSC-MediumItalic.otf"
  font "Alegreya-Sans-#{version}/fonts/otf/AlegreyaSansSC-Regular.otf"
  font "Alegreya-Sans-#{version}/fonts/otf/AlegreyaSansSC-Thin.otf"
  font "Alegreya-Sans-#{version}/fonts/otf/AlegreyaSansSC-ThinItalic.otf"

  # No zap stanza required
end