cask "font-glow-sans-j-normal" do
  version "0.93"
  sha256 "b4a84f6d277d3c0ec6e833ac0fe25b40545ededc19df5fb4643731eef0f730a2"

  url "https:github.comwelaiglow-sansreleasesdownloadv#{version}GlowSansJ-Normal-v#{version}.zip"
  name "Glow Sans J Normal"
  homepage "https:github.comwelaiglow-sans"

  deprecate! date: "2024-02-17", because: :discontinued

  font "GlowSansJ-Normal-Bold.otf"
  font "GlowSansJ-Normal-Book.otf"
  font "GlowSansJ-Normal-ExtraBold.otf"
  font "GlowSansJ-Normal-ExtraLight.otf"
  font "GlowSansJ-Normal-Heavy.otf"
  font "GlowSansJ-Normal-Light.otf"
  font "GlowSansJ-Normal-Medium.otf"
  font "GlowSansJ-Normal-Regular.otf"
  font "GlowSansJ-Normal-Thin.otf"

  # No zap stanza required
end