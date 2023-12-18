cask "zeronet" do
  version "0.7.1"
  sha256 :no_check

  url "https:github.comHelloZeroNetZeroNet-distarchivemacZeroNet-dist-mac.zip",
      verified: "github.comHelloZeroNetZeroNet-dist"
  name "ZeroNet"
  homepage "https:zeronet.io"

  livecheck do
    url "https:github.comHelloZeroNetZeroNetreleases"
    strategy :github_latest
  end

  app "ZeroNet-dist-macZeroNet.app"

  zap trash: [
    "~LibraryApplication SupportZeroNet",
    "~LibrarySaved Application Stateorg.pythonmac.unspecified.ZeroNet.savedState",
  ]
end