class WineScripts < Formula
  desc "Command-line utility scripts for wine on macOS"
  homepage "https://github.com/nicerloop/wine-scripts"
  url "https://ghproxy.com/https://github.com/nicerloop/wine-scripts/archive/refs/tags/v1.5.2.tar.gz"
  sha256 "5a030ca46dd70b4c9c9f8ddac5a26cdc80db3bbf1006ff312fa194dbe55096cf"

  depends_on "coreutils"
  depends_on "exiftool"
  depends_on "icoutils"
  depends_on "winetricks"

  def install
    bin.install "wine-setup-dotnet48"
    bin.install "wine-wrap-application"
  end
end