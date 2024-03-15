cask "openbb-terminal" do
  # raised an issue about the x86.64 typo, https:github.comOpenBB-financeOpenBBTerminalissues5405
  arch arm: "ARM64", intel: "x86.64"

  version "3.2.5"
  sha256 arm:   "80c12368b62b135bb74736a411c9adf277dbed46969b0b49be46cbd768afb618",
         intel: "d5a386b10ba076a69a7e642034a55b1c5e53ef32c8fc6383985199709b06572e"

  url "https:github.comOpenBB-financeOpenBBTerminalreleasesdownloadv#{version}#{arch}.MacOS.OpenBB.Terminal.v#{version}.pkg",
      verified: "github.comOpenBB-financeOpenBBTerminal"
  name "OpenBB Terminal"
  desc "Open-source investment research terminal"
  homepage "https:openbb.co"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :monterey"

  pkg "#{arch}.MacOS.OpenBB.Terminal.v#{version}.pkg"

  uninstall pkgutil: "OpenBB Terminal"

  zap trash: [
    "~.openbb_terminal",
    "~OpenBBUserData",
  ]
end