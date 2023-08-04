class WineScripts < Formula
  desc "Command-line utility scripts for wine on macOS"
  homepage "https://github.com/nicerloop/wine-scripts"
  url "https://ghproxy.com/https://github.com/nicerloop/wine-scripts/archive/refs/tags/v1.5.3.tar.gz"
  sha256 "65053618c2cde5e3d775a3cdc502ca9bd8a66c67cc54eb2da3a0f597c3629ad9"

  depends_on "coreutils"
  depends_on "exiftool"
  depends_on "icoutils"
  depends_on "winetricks"

  def install
    bin.install "wine-setup-dotnet48"
    bin.install "wine-wrap-application"
  end
end