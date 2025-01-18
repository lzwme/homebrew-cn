cask "termora" do
  arch arm: "aarch64", intel: "x86-64"

  version "1.0.2"
  sha256 arm:   "ca97a8dc8549db24b548f1ee8d8416dfb670cce16ee313fc434e806ed7468098",
         intel: "025aadf7a900d213e3047cfa4f534147cfdec91ba4ad6bd8c70a3ca4c720dae2"

  url "https:github.comTermoraDevtermorareleasesdownload#{version}termora-#{version}-osx-#{arch}.dmg"
  name "Termora"
  desc "Terminal emulator and SSH client"
  homepage "https:github.comTermoraDevtermora"

  auto_updates true
  depends_on macos: ">= :high_sierra"

  app "Termora.app"

  zap trash: "~.termora"
end