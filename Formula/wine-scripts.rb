class WineScripts < Formula
  desc "Command-line utility scripts for wine on macOS"
  homepage "https://github.com/nicerloop/macos-scripts"
  url "https://ghproxy.com/https://github.com/nicerloop/wine-scripts/archive/refs/tags/v1.5.1.tar.gz"
  sha256 "97f55d0aabb35309b0f1778d92bac1ee3c53547fe87eeaec679c1e79fb112673"

  depends_on "coreutils"
  depends_on "exiftool"
  depends_on "gcenx/wine/wine-crossover@21"
  depends_on "gcenx/wine/winetricks"
  depends_on "icoutils"

  def install
    bin.install "wine"
    bin.install "wine-preloader"
    bin.install "wine-setup-dotnet48"
    bin.install "wine-wrap-application"
  end
end