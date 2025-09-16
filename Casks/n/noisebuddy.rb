cask "noisebuddy" do
  version "1.3"
  sha256 "e16dae432d0c77aa394e62abb6b2452cab94150614638e998d2494c86a44beeb"

  url "https://ghfast.top/https://github.com/insidegui/NoiseBuddy/releases/download/#{version}/NoiseBuddy_v#{version}.zip"
  name "NoiseBuddy"
  homepage "https://github.com/insidegui/NoiseBuddy"

  deprecate! date: "2024-09-08", because: :unmaintained
  disable! date: "2025-09-09", because: :unmaintained

  app "NoiseBuddy.app"
end