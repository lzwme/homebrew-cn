cask "font-firago" do
  version "1.000"
  sha256 "b2f97f1ee02921ca1776903fa0e6f1358b017bf854c0e8776b6b8512e3c9d4a1"

  url "https://ghfast.top/https://github.com/bBoxType/FiraGO/archive/refs/tags/#{version}.tar.gz",
      verified: "github.com/bBoxType/FiraGO/"
  name "FiraGO"
  homepage "https://bboxtype.com/typefaces/FiraGO/"

  no_autobump! because: :requires_manual_review

  font "FiraGO-#{version}/Fonts/FiraGO_OTF/Italic/FiraGO-BoldItalic.otf"
  font "FiraGO-#{version}/Fonts/FiraGO_OTF/Italic/FiraGO-BookItalic.otf"
  font "FiraGO-#{version}/Fonts/FiraGO_OTF/Italic/FiraGO-EightItalic.otf"
  font "FiraGO-#{version}/Fonts/FiraGO_OTF/Italic/FiraGO-ExtraBoldItalic.otf"
  font "FiraGO-#{version}/Fonts/FiraGO_OTF/Italic/FiraGO-ExtraLightItalic.otf"
  font "FiraGO-#{version}/Fonts/FiraGO_OTF/Italic/FiraGO-FourItalic.otf"
  font "FiraGO-#{version}/Fonts/FiraGO_OTF/Italic/FiraGO-HairItalic.otf"
  font "FiraGO-#{version}/Fonts/FiraGO_OTF/Italic/FiraGO-HeavyItalic.otf"
  font "FiraGO-#{version}/Fonts/FiraGO_OTF/Italic/FiraGO-Italic.otf"
  font "FiraGO-#{version}/Fonts/FiraGO_OTF/Italic/FiraGO-LightItalic.otf"
  font "FiraGO-#{version}/Fonts/FiraGO_OTF/Italic/FiraGO-MediumItalic.otf"
  font "FiraGO-#{version}/Fonts/FiraGO_OTF/Italic/FiraGO-SemiBoldItalic.otf"
  font "FiraGO-#{version}/Fonts/FiraGO_OTF/Italic/FiraGO-ThinItalic.otf"
  font "FiraGO-#{version}/Fonts/FiraGO_OTF/Italic/FiraGO-TwoItalic.otf"
  font "FiraGO-#{version}/Fonts/FiraGO_OTF/Italic/FiraGO-UltraLightItalic.otf"
  font "FiraGO-#{version}/Fonts/FiraGO_OTF/Roman/FiraGO-Bold.otf"
  font "FiraGO-#{version}/Fonts/FiraGO_OTF/Roman/FiraGO-Book.otf"
  font "FiraGO-#{version}/Fonts/FiraGO_OTF/Roman/FiraGO-Eight.otf"
  font "FiraGO-#{version}/Fonts/FiraGO_OTF/Roman/FiraGO-ExtraBold.otf"
  font "FiraGO-#{version}/Fonts/FiraGO_OTF/Roman/FiraGO-ExtraLight.otf"
  font "FiraGO-#{version}/Fonts/FiraGO_OTF/Roman/FiraGO-Four.otf"
  font "FiraGO-#{version}/Fonts/FiraGO_OTF/Roman/FiraGO-Hair.otf"
  font "FiraGO-#{version}/Fonts/FiraGO_OTF/Roman/FiraGO-Heavy.otf"
  font "FiraGO-#{version}/Fonts/FiraGO_OTF/Roman/FiraGO-Light.otf"
  font "FiraGO-#{version}/Fonts/FiraGO_OTF/Roman/FiraGO-Medium.otf"
  font "FiraGO-#{version}/Fonts/FiraGO_OTF/Roman/FiraGO-Regular.otf"
  font "FiraGO-#{version}/Fonts/FiraGO_OTF/Roman/FiraGO-SemiBold.otf"
  font "FiraGO-#{version}/Fonts/FiraGO_OTF/Roman/FiraGO-Thin.otf"
  font "FiraGO-#{version}/Fonts/FiraGO_OTF/Roman/FiraGO-Two.otf"
  font "FiraGO-#{version}/Fonts/FiraGO_OTF/Roman/FiraGO-UltraLight.otf"

  # No zap stanza required
end