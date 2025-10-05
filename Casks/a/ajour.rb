cask "ajour" do
  version "1.3.2"
  sha256 "41c4154a5d60219172ac6313780a8ac037aa1542133b672076350b345a2c2bd2"

  url "https://ghfast.top/https://github.com/casperstorm/ajour/releases/download/#{version}/ajour.dmg"
  name "Ajour"
  desc "World of Warcraft addon manager"
  homepage "https://github.com/casperstorm/ajour"

  deprecate! date: "2024-10-04", because: :unmaintained
  disable! date: "2025-10-04", because: :unmaintained

  app "Ajour.app"

  zap trash: "~/.config/ajour"

  caveats do
    requires_rosetta
  end
end