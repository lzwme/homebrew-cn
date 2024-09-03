cask "font-ibm-plex-sans-jp" do
  version "1.0.0"
  sha256 "6946948f66b511560786fd0ec7d561de985a1f6d8692b0ed44fbf7d880a994fa"

  url "https:github.comIBMplexreleasesdownload%40ibm%2Fplex-sans-jp%40#{version}ibm-plex-sans-jp.zip"
  name "IBM Plex Sans JP"
  homepage "https:github.comIBMplex"

  livecheck do
    url :url
    regex(%r{^@ibmplex-sans-jp@?(\d+(?:\.\d+)+)$}i)
  end

  font "ibm-plex-sans-jpfontscompleteotfhintedIBMPlexSansJP-Bold.otf"
  font "ibm-plex-sans-jpfontscompleteotfhintedIBMPlexSansJP-ExtraLight.otf"
  font "ibm-plex-sans-jpfontscompleteotfhintedIBMPlexSansJP-Light.otf"
  font "ibm-plex-sans-jpfontscompleteotfhintedIBMPlexSansJP-Medium.otf"
  font "ibm-plex-sans-jpfontscompleteotfhintedIBMPlexSansJP-Regular.otf"
  font "ibm-plex-sans-jpfontscompleteotfhintedIBMPlexSansJP-SemiBold.otf"
  font "ibm-plex-sans-jpfontscompleteotfhintedIBMPlexSansJP-Text.otf"
  font "ibm-plex-sans-jpfontscompleteotfhintedIBMPlexSansJP-Thin.otf"

  # No zap stanza required
end