cask "font-ibm-plex-sans-kr" do
  version "1.0.0"
  sha256 "b977effaabce2328f888db8590f0989c162cb9a9aad9d70949f3910552e6652b"

  url "https:github.comIBMplexreleasesdownload%40ibm%2Fplex-sans-kr%40#{version}ibm-plex-sans-kr.zip"
  name "IBM Plex Sans KR"
  homepage "https:github.comIBMplex"

  livecheck do
    url :url
    regex(%r{^@ibmplex-sans-kr@?(\d+(?:\.\d+)+)$}i)
  end

  font "ibm-plex-sans-krfontscompleteotfIBMPlexSansKR-Bold.otf"
  font "ibm-plex-sans-krfontscompleteotfIBMPlexSansKR-ExtraLight.otf"
  font "ibm-plex-sans-krfontscompleteotfIBMPlexSansKR-Light.otf"
  font "ibm-plex-sans-krfontscompleteotfIBMPlexSansKR-Medium.otf"
  font "ibm-plex-sans-krfontscompleteotfIBMPlexSansKR-Regular.otf"
  font "ibm-plex-sans-krfontscompleteotfIBMPlexSansKR-SemiBold.otf"
  font "ibm-plex-sans-krfontscompleteotfIBMPlexSansKR-Text.otf"
  font "ibm-plex-sans-krfontscompleteotfIBMPlexSansKR-Thin.otf"

  # No zap stanza required
end