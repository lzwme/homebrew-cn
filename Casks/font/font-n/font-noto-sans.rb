cask "font-noto-sans" do
  version "2.013"
  sha256 "9fd595dd701d7ea103a9ba8a9cfdcf0c35c5574ef754fecabe718eadad8bccde"

  url "https:github.comnotofontslatin-greek-cyrillicreleasesdownloadNotoSans-v#{version}NotoSans-v#{version}.zip",
      verified: "github.comnotofonts"
  name "Noto Sans"
  homepage "https:notofonts.github.io"

  livecheck do
    url :url
    regex(^NotoSans-v?(\d+(?:\.\d+)+)$i)
  end

  font "NotoSansunhintedvariableNotoSans-Italic[wdth,wght].ttf"
  font "NotoSansunhintedvariableNotoSans[wdth,wght].ttf"
  font "NotoSansunhintedttfNotoSans-Black.ttf"
  font "NotoSansunhintedttfNotoSans-BlackItalic.ttf"
  font "NotoSansunhintedttfNotoSans-Bold.ttf"
  font "NotoSansunhintedttfNotoSans-BoldItalic.ttf"
  font "NotoSansunhintedttfNotoSans-Condensed.ttf"
  font "NotoSansunhintedttfNotoSans-CondensedBlack.ttf"
  font "NotoSansunhintedttfNotoSans-CondensedBlackItalic.ttf"
  font "NotoSansunhintedttfNotoSans-CondensedBold.ttf"
  font "NotoSansunhintedttfNotoSans-CondensedBoldItalic.ttf"
  font "NotoSansunhintedttfNotoSans-CondensedExtraBold.ttf"
  font "NotoSansunhintedttfNotoSans-CondensedExtraBoldItalic.ttf"
  font "NotoSansunhintedttfNotoSans-CondensedExtraLight.ttf"
  font "NotoSansunhintedttfNotoSans-CondensedExtraLightItalic.ttf"
  font "NotoSansunhintedttfNotoSans-CondensedItalic.ttf"
  font "NotoSansunhintedttfNotoSans-CondensedLight.ttf"
  font "NotoSansunhintedttfNotoSans-CondensedLightItalic.ttf"
  font "NotoSansunhintedttfNotoSans-CondensedMedium.ttf"
  font "NotoSansunhintedttfNotoSans-CondensedMediumItalic.ttf"
  font "NotoSansunhintedttfNotoSans-CondensedSemiBold.ttf"
  font "NotoSansunhintedttfNotoSans-CondensedSemiBoldItalic.ttf"
  font "NotoSansunhintedttfNotoSans-CondensedThin.ttf"
  font "NotoSansunhintedttfNotoSans-CondensedThinItalic.ttf"
  font "NotoSansunhintedttfNotoSans-ExtraBold.ttf"
  font "NotoSansunhintedttfNotoSans-ExtraBoldItalic.ttf"
  font "NotoSansunhintedttfNotoSans-ExtraCondensed.ttf"
  font "NotoSansunhintedttfNotoSans-ExtraCondensedBlack.ttf"
  font "NotoSansunhintedttfNotoSans-ExtraCondensedBlackItalic.ttf"
  font "NotoSansunhintedttfNotoSans-ExtraCondensedBold.ttf"
  font "NotoSansunhintedttfNotoSans-ExtraCondensedBoldItalic.ttf"
  font "NotoSansunhintedttfNotoSans-ExtraCondensedExtraBold.ttf"
  font "NotoSansunhintedttfNotoSans-ExtraCondensedExtraBoldItalic.ttf"
  font "NotoSansunhintedttfNotoSans-ExtraCondensedExtraLight.ttf"
  font "NotoSansunhintedttfNotoSans-ExtraCondensedExtraLightItalic.ttf"
  font "NotoSansunhintedttfNotoSans-ExtraCondensedItalic.ttf"
  font "NotoSansunhintedttfNotoSans-ExtraCondensedLight.ttf"
  font "NotoSansunhintedttfNotoSans-ExtraCondensedLightItalic.ttf"
  font "NotoSansunhintedttfNotoSans-ExtraCondensedMedium.ttf"
  font "NotoSansunhintedttfNotoSans-ExtraCondensedMediumItalic.ttf"
  font "NotoSansunhintedttfNotoSans-ExtraCondensedSemiBold.ttf"
  font "NotoSansunhintedttfNotoSans-ExtraCondensedSemiBoldItalic.ttf"
  font "NotoSansunhintedttfNotoSans-ExtraCondensedThin.ttf"
  font "NotoSansunhintedttfNotoSans-ExtraCondensedThinItalic.ttf"
  font "NotoSansunhintedttfNotoSans-ExtraLight.ttf"
  font "NotoSansunhintedttfNotoSans-ExtraLightItalic.ttf"
  font "NotoSansunhintedttfNotoSans-Italic.ttf"
  font "NotoSansunhintedttfNotoSans-Light.ttf"
  font "NotoSansunhintedttfNotoSans-LightItalic.ttf"
  font "NotoSansunhintedttfNotoSans-Medium.ttf"
  font "NotoSansunhintedttfNotoSans-MediumItalic.ttf"
  font "NotoSansunhintedttfNotoSans-Regular.ttf"
  font "NotoSansunhintedttfNotoSans-SemiBold.ttf"
  font "NotoSansunhintedttfNotoSans-SemiBoldItalic.ttf"
  font "NotoSansunhintedttfNotoSans-SemiCondensed.ttf"
  font "NotoSansunhintedttfNotoSans-SemiCondensedBlack.ttf"
  font "NotoSansunhintedttfNotoSans-SemiCondensedBlackItalic.ttf"
  font "NotoSansunhintedttfNotoSans-SemiCondensedBold.ttf"
  font "NotoSansunhintedttfNotoSans-SemiCondensedBoldItalic.ttf"
  font "NotoSansunhintedttfNotoSans-SemiCondensedExtraBold.ttf"
  font "NotoSansunhintedttfNotoSans-SemiCondensedExtraBoldItalic.ttf"
  font "NotoSansunhintedttfNotoSans-SemiCondensedExtraLight.ttf"
  font "NotoSansunhintedttfNotoSans-SemiCondensedExtraLightItalic.ttf"
  font "NotoSansunhintedttfNotoSans-SemiCondensedItalic.ttf"
  font "NotoSansunhintedttfNotoSans-SemiCondensedLight.ttf"
  font "NotoSansunhintedttfNotoSans-SemiCondensedLightItalic.ttf"
  font "NotoSansunhintedttfNotoSans-SemiCondensedMedium.ttf"
  font "NotoSansunhintedttfNotoSans-SemiCondensedMediumItalic.ttf"
  font "NotoSansunhintedttfNotoSans-SemiCondensedSemiBold.ttf"
  font "NotoSansunhintedttfNotoSans-SemiCondensedSemiBoldItalic.ttf"
  font "NotoSansunhintedttfNotoSans-SemiCondensedThin.ttf"
  font "NotoSansunhintedttfNotoSans-SemiCondensedThinItalic.ttf"
  font "NotoSansunhintedttfNotoSans-Thin.ttf"
  font "NotoSansunhintedttfNotoSans-ThinItalic.ttf"
end