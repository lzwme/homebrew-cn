cask "font-lxgw-marker-gothic" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainofllxgwmarkergothicLXGWMarkerGothic-Regular.ttf",
      verified: "github.comgooglefonts"
  name "LXGW Marker Gothic"
  homepage "https:fonts.google.comspecimenLXGW+Marker+Gothic"

  font "LXGWMarkerGothic-Regular.ttf"

  # No zap stanza required
end