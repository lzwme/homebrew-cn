cask "font-iosevka-curly-slab" do
  version "29.2.0"
  sha256 "b58107e9298ade7d1d007329adecec46d7e040987ea08620c29fd27814880f51"

  url "https:github.combe5invisIosevkareleasesdownloadv#{version}PkgTTC-IosevkaCurlySlab-#{version}.zip"
  name "Iosevka Curly Slab"
  desc "Sans-serif, slab-serif, monospace and quasi‑proportional typeface family"
  homepage "https:github.combe5invisIosevka"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "IosevkaCurlySlab-Bold.ttc"
  font "IosevkaCurlySlab-ExtraBold.ttc"
  font "IosevkaCurlySlab-ExtraLight.ttc"
  font "IosevkaCurlySlab-Heavy.ttc"
  font "IosevkaCurlySlab-Light.ttc"
  font "IosevkaCurlySlab-Medium.ttc"
  font "IosevkaCurlySlab-Regular.ttc"
  font "IosevkaCurlySlab-SemiBold.ttc"
  font "IosevkaCurlySlab-Thin.ttc"

  # No zap stanza required
end