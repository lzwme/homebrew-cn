cask "font-devicons" do
  version "1.8.0"
  sha256 "fc0baa260f54832c059d1d9eab3798ae758d1a1cf0c1695e9883aab85d9a4308"

  url "https:github.comvorillazdeviconsarchive#{version}.zip",
      verified: "github.comvorillazdevicons"
  name "Devicons"
  homepage "https:vorillaz.github.iodevicons"

  font "devicons-#{version}fontsdevicons.ttf"

  # No zap stanza required
end