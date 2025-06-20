cask "font-tamzen" do
  version "1.11.6"
  sha256 "f35173177f9407bb78e48a93169f1981ae5c945d51fef6e4eeae85c1c9192577"

  url "https:github.comsunakutamzen-fontarchiverefstagsTamzen-#{version}.tar.gz"
  name "Tamzen"
  homepage "https:github.comsunakutamzen-font"

  no_autobump! because: :requires_manual_review

  font "tamzen-font-Tamzen-#{version}ttfTamzen10x20b.ttf"
  font "tamzen-font-Tamzen-#{version}ttfTamzen10x20r.ttf"
  font "tamzen-font-Tamzen-#{version}ttfTamzen5x9b.ttf"
  font "tamzen-font-Tamzen-#{version}ttfTamzen5x9r.ttf"
  font "tamzen-font-Tamzen-#{version}ttfTamzen6x12b.ttf"
  font "tamzen-font-Tamzen-#{version}ttfTamzen6x12r.ttf"
  font "tamzen-font-Tamzen-#{version}ttfTamzen7x13b.ttf"
  font "tamzen-font-Tamzen-#{version}ttfTamzen7x13r.ttf"
  font "tamzen-font-Tamzen-#{version}ttfTamzen7x14b.ttf"
  font "tamzen-font-Tamzen-#{version}ttfTamzen7x14r.ttf"
  font "tamzen-font-Tamzen-#{version}ttfTamzen8x15b.ttf"
  font "tamzen-font-Tamzen-#{version}ttfTamzen8x15r.ttf"
  font "tamzen-font-Tamzen-#{version}ttfTamzen8x16b.ttf"
  font "tamzen-font-Tamzen-#{version}ttfTamzen8x16r.ttf"
  font "tamzen-font-Tamzen-#{version}ttfTamzenForPowerline10x20b.ttf"
  font "tamzen-font-Tamzen-#{version}ttfTamzenForPowerline10x20r.ttf"
  font "tamzen-font-Tamzen-#{version}ttfTamzenForPowerline5x9b.ttf"
  font "tamzen-font-Tamzen-#{version}ttfTamzenForPowerline5x9r.ttf"
  font "tamzen-font-Tamzen-#{version}ttfTamzenForPowerline6x12b.ttf"
  font "tamzen-font-Tamzen-#{version}ttfTamzenForPowerline6x12r.ttf"
  font "tamzen-font-Tamzen-#{version}ttfTamzenForPowerline7x13b.ttf"
  font "tamzen-font-Tamzen-#{version}ttfTamzenForPowerline7x13r.ttf"
  font "tamzen-font-Tamzen-#{version}ttfTamzenForPowerline7x14b.ttf"
  font "tamzen-font-Tamzen-#{version}ttfTamzenForPowerline7x14r.ttf"
  font "tamzen-font-Tamzen-#{version}ttfTamzenForPowerline8x15b.ttf"
  font "tamzen-font-Tamzen-#{version}ttfTamzenForPowerline8x15r.ttf"
  font "tamzen-font-Tamzen-#{version}ttfTamzenForPowerline8x16b.ttf"
  font "tamzen-font-Tamzen-#{version}ttfTamzenForPowerline8x16r.ttf"

  # No zap stanza required
end