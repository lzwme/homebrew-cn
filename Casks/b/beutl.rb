cask "beutl" do
  arch arm: "arm64", intel: "x64"

  version "1.0.5"
  sha256 arm:   "acd1881f8d59410fd9e29d3293f2b8f72a1043dcbebe38aa4cce78c65276c276",
         intel: "d0e9c42994e030f48023459ec64eea48e9658bf5821e3e5dc0682d353574acde"

  url "https:github.comb-editorbeutlreleasesdownloadv#{version}Beutl.osx_#{arch}.app.zip",
      verified: "github.comb-editorbeutl"
  name "Beutl"
  desc "Video editor"
  homepage "https:beutl.beditor.net"

  depends_on macos: ">= :monterey"
  depends_on formula: "ffmpeg@6"

  app "Beutl.app"

  uninstall quit: "net.beditor.beutl"

  zap trash: [
    "~.beutl",
    "~LibrarySaved Application Statenet.beditor.beutl.savedState",
  ]
end