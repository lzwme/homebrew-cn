cask "font-firago" do
  version "1.000"
  sha256 "b2f97f1ee02921ca1776903fa0e6f1358b017bf854c0e8776b6b8512e3c9d4a1"

  url "https:github.combBoxTypeFiraGOarchiverefstags#{version}.tar.gz",
      verified: "github.combBoxTypeFiraGO"
  name "FiraGO"
  homepage "https:bboxtype.comtypefacesFiraGO"

  no_autobump! because: :requires_manual_review

  font "FiraGO-#{version}FontsFiraGO_OTFItalicFiraGO-BoldItalic.otf"
  font "FiraGO-#{version}FontsFiraGO_OTFItalicFiraGO-BookItalic.otf"
  font "FiraGO-#{version}FontsFiraGO_OTFItalicFiraGO-EightItalic.otf"
  font "FiraGO-#{version}FontsFiraGO_OTFItalicFiraGO-ExtraBoldItalic.otf"
  font "FiraGO-#{version}FontsFiraGO_OTFItalicFiraGO-ExtraLightItalic.otf"
  font "FiraGO-#{version}FontsFiraGO_OTFItalicFiraGO-FourItalic.otf"
  font "FiraGO-#{version}FontsFiraGO_OTFItalicFiraGO-HairItalic.otf"
  font "FiraGO-#{version}FontsFiraGO_OTFItalicFiraGO-HeavyItalic.otf"
  font "FiraGO-#{version}FontsFiraGO_OTFItalicFiraGO-Italic.otf"
  font "FiraGO-#{version}FontsFiraGO_OTFItalicFiraGO-LightItalic.otf"
  font "FiraGO-#{version}FontsFiraGO_OTFItalicFiraGO-MediumItalic.otf"
  font "FiraGO-#{version}FontsFiraGO_OTFItalicFiraGO-SemiBoldItalic.otf"
  font "FiraGO-#{version}FontsFiraGO_OTFItalicFiraGO-ThinItalic.otf"
  font "FiraGO-#{version}FontsFiraGO_OTFItalicFiraGO-TwoItalic.otf"
  font "FiraGO-#{version}FontsFiraGO_OTFItalicFiraGO-UltraLightItalic.otf"
  font "FiraGO-#{version}FontsFiraGO_OTFRomanFiraGO-Bold.otf"
  font "FiraGO-#{version}FontsFiraGO_OTFRomanFiraGO-Book.otf"
  font "FiraGO-#{version}FontsFiraGO_OTFRomanFiraGO-Eight.otf"
  font "FiraGO-#{version}FontsFiraGO_OTFRomanFiraGO-ExtraBold.otf"
  font "FiraGO-#{version}FontsFiraGO_OTFRomanFiraGO-ExtraLight.otf"
  font "FiraGO-#{version}FontsFiraGO_OTFRomanFiraGO-Four.otf"
  font "FiraGO-#{version}FontsFiraGO_OTFRomanFiraGO-Hair.otf"
  font "FiraGO-#{version}FontsFiraGO_OTFRomanFiraGO-Heavy.otf"
  font "FiraGO-#{version}FontsFiraGO_OTFRomanFiraGO-Light.otf"
  font "FiraGO-#{version}FontsFiraGO_OTFRomanFiraGO-Medium.otf"
  font "FiraGO-#{version}FontsFiraGO_OTFRomanFiraGO-Regular.otf"
  font "FiraGO-#{version}FontsFiraGO_OTFRomanFiraGO-SemiBold.otf"
  font "FiraGO-#{version}FontsFiraGO_OTFRomanFiraGO-Thin.otf"
  font "FiraGO-#{version}FontsFiraGO_OTFRomanFiraGO-Two.otf"
  font "FiraGO-#{version}FontsFiraGO_OTFRomanFiraGO-UltraLight.otf"

  # No zap stanza required
end