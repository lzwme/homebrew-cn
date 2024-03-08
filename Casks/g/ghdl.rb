cask "ghdl" do
  arch arm: "llvm", intel: "mcode"

  version "4.0.0"
  sha256 arm:   "55140a3fd5762f051d751db1aeb8f42d53100beb8ac6468e4b1b517b7c50ab02",
         intel: "d35d2e9bba77759721268ef032642ac9120d223e05675a3005bc933495089f21"

  url "https:github.comghdlghdlreleasesdownloadv#{version}ghdl-macos-11-#{arch}.tgz"
  name "ghdl"
  desc "VHDL 20089387 simulator"
  homepage "https:github.comghdlghdl"

  livecheck do
    url :url
    strategy :github_latest
  end

  binary "binghdl"

  # No zap stanza required
end