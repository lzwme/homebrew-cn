cask "font-ibm-plex-mono" do
  version "1.1.0"
  sha256 "4bfc936d0e1fd19db6327a3786eabdbc3dc0d464500576f6458f6706df68d26c"

  url "https:github.comIBMplexreleasesdownload%40ibm%2Fplex-mono%40#{version}ibm-plex-mono.zip"
  name "IBM Plex Mono"
  homepage "https:github.comIBMplex"

  livecheck do
    url :url
    regex(%r{^@ibmplex-mono@?(\d+(?:\.\d+)+)$}i)
  end

  font "ibm-plex-monofontscompleteotfIBMPlexMono-Bold.otf"
  font "ibm-plex-monofontscompleteotfIBMPlexMono-BoldItalic.otf"
  font "ibm-plex-monofontscompleteotfIBMPlexMono-ExtraLight.otf"
  font "ibm-plex-monofontscompleteotfIBMPlexMono-ExtraLightItalic.otf"
  font "ibm-plex-monofontscompleteotfIBMPlexMono-Italic.otf"
  font "ibm-plex-monofontscompleteotfIBMPlexMono-Light.otf"
  font "ibm-plex-monofontscompleteotfIBMPlexMono-LightItalic.otf"
  font "ibm-plex-monofontscompleteotfIBMPlexMono-Medium.otf"
  font "ibm-plex-monofontscompleteotfIBMPlexMono-MediumItalic.otf"
  font "ibm-plex-monofontscompleteotfIBMPlexMono-Regular.otf"
  font "ibm-plex-monofontscompleteotfIBMPlexMono-SemiBold.otf"
  font "ibm-plex-monofontscompleteotfIBMPlexMono-SemiBoldItalic.otf"
  font "ibm-plex-monofontscompleteotfIBMPlexMono-Text.otf"
  font "ibm-plex-monofontscompleteotfIBMPlexMono-TextItalic.otf"
  font "ibm-plex-monofontscompleteotfIBMPlexMono-Thin.otf"
  font "ibm-plex-monofontscompleteotfIBMPlexMono-ThinItalic.otf"

  # No zap stanza required
end