cask "font-ysabeau" do
  version "2.006"
  sha256 "3adc3acc959f24541219ee697af4e906069393bb72a266b05579a27458db77d8"

  url "https://ghfast.top/https://github.com/CatharsisFonts/Ysabeau/releases/download/v#{version}/Ysabeau_Install_v#{version}.zip"
  name "Ysabeau"
  homepage "https://github.com/CatharsisFonts/Ysabeau/"

  no_autobump! because: :requires_manual_review

  font "Ysabeau_Install_v#{version}/Ysabeau-Black.otf"
  font "Ysabeau_Install_v#{version}/Ysabeau-BlackItalic.otf"
  font "Ysabeau_Install_v#{version}/Ysabeau-Bold.otf"
  font "Ysabeau_Install_v#{version}/Ysabeau-BoldItalic.otf"
  font "Ysabeau_Install_v#{version}/Ysabeau-ExtraBlack.otf"
  font "Ysabeau_Install_v#{version}/Ysabeau-ExtraBlackItalic.otf"
  font "Ysabeau_Install_v#{version}/Ysabeau-ExtraBold.otf"
  font "Ysabeau_Install_v#{version}/Ysabeau-ExtraBoldItalic.otf"
  font "Ysabeau_Install_v#{version}/Ysabeau-ExtraLight.otf"
  font "Ysabeau_Install_v#{version}/Ysabeau-ExtraLightItalic.otf"
  font "Ysabeau_Install_v#{version}/Ysabeau-ExtraThin.otf"
  font "Ysabeau_Install_v#{version}/Ysabeau-ExtraThinItalic.otf"
  font "Ysabeau_Install_v#{version}/Ysabeau-Hairline.otf"
  font "Ysabeau_Install_v#{version}/Ysabeau-HairlineItalic.otf"
  font "Ysabeau_Install_v#{version}/Ysabeau-Italic.otf"
  font "Ysabeau_Install_v#{version}/Ysabeau-Light.otf"
  font "Ysabeau_Install_v#{version}/Ysabeau-LightItalic.otf"
  font "Ysabeau_Install_v#{version}/Ysabeau-Medium.otf"
  font "Ysabeau_Install_v#{version}/Ysabeau-MediumItalic.otf"
  font "Ysabeau_Install_v#{version}/Ysabeau-Regular.otf"
  font "Ysabeau_Install_v#{version}/Ysabeau-SemiBold.otf"
  font "Ysabeau_Install_v#{version}/Ysabeau-SemiBoldItalic.otf"
  font "Ysabeau_Install_v#{version}/Ysabeau-Thin.otf"
  font "Ysabeau_Install_v#{version}/Ysabeau-ThinItalic.otf"
  font "Ysabeau_Install_v#{version}/YsabeauInfant-Black.otf"
  font "Ysabeau_Install_v#{version}/YsabeauInfant-BlackItalic.otf"
  font "Ysabeau_Install_v#{version}/YsabeauInfant-Bold.otf"
  font "Ysabeau_Install_v#{version}/YsabeauInfant-BoldItalic.otf"
  font "Ysabeau_Install_v#{version}/YsabeauInfant-ExtraBlack.otf"
  font "Ysabeau_Install_v#{version}/YsabeauInfant-ExtraBlackItalic.otf"
  font "Ysabeau_Install_v#{version}/YsabeauInfant-ExtraBold.otf"
  font "Ysabeau_Install_v#{version}/YsabeauInfant-ExtraBoldItalic.otf"
  font "Ysabeau_Install_v#{version}/YsabeauInfant-ExtraLight.otf"
  font "Ysabeau_Install_v#{version}/YsabeauInfant-ExtraLightItalic.otf"
  font "Ysabeau_Install_v#{version}/YsabeauInfant-Hairline.otf"
  font "Ysabeau_Install_v#{version}/YsabeauInfant-HairlineItalic.otf"
  font "Ysabeau_Install_v#{version}/YsabeauInfant-Italic.otf"
  font "Ysabeau_Install_v#{version}/YsabeauInfant-Light.otf"
  font "Ysabeau_Install_v#{version}/YsabeauInfant-LightItalic.otf"
  font "Ysabeau_Install_v#{version}/YsabeauInfant-Medium.otf"
  font "Ysabeau_Install_v#{version}/YsabeauInfant-MediumItalic.otf"
  font "Ysabeau_Install_v#{version}/YsabeauInfant-Regular.otf"
  font "Ysabeau_Install_v#{version}/YsabeauInfant-SemiBold.otf"
  font "Ysabeau_Install_v#{version}/YsabeauInfant-SemiBoldItalic.otf"
  font "Ysabeau_Install_v#{version}/YsabeauInfant-Thin.otf"
  font "Ysabeau_Install_v#{version}/YsabeauInfant-ThinItalic.otf"
  font "Ysabeau_Install_v#{version}/YsabeauSC-Black.otf"
  font "Ysabeau_Install_v#{version}/YsabeauSC-Bold.otf"
  font "Ysabeau_Install_v#{version}/YsabeauSC-ExtraBlack.otf"
  font "Ysabeau_Install_v#{version}/YsabeauSC-ExtraBold.otf"
  font "Ysabeau_Install_v#{version}/YsabeauSC-ExtraLight.otf"
  font "Ysabeau_Install_v#{version}/YsabeauSC-Hairline.otf"
  font "Ysabeau_Install_v#{version}/YsabeauSC-Light.otf"
  font "Ysabeau_Install_v#{version}/YsabeauSC-Medium.otf"
  font "Ysabeau_Install_v#{version}/YsabeauSC-Regular.otf"
  font "Ysabeau_Install_v#{version}/YsabeauSC-SemiBold.otf"
  font "Ysabeau_Install_v#{version}/YsabeauSC-Thin.otf"

  # No zap stanza required
end