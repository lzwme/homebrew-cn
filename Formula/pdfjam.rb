# see https:github.comFLEWID-ABhomebrew-pdfjamblobmasterpdfjam.rb for reference
class Pdfjam < Formula
  desc "Package for manipulating PDF files"
  homepage "https:github.comrrthomaspdfjam"
  url "https:github.comrrthomaspdfjamreleasesdownloadv4.1pdfjam-4.1.tar.gz"
  sha256 "f90dd65427ddedbcce4e43d2dc2ff4a5c4fe65cc8e10c8853e6c8a748caf6a2b"
  license "GPL-2.0-or-later"

  def install
    bin.install Dir["bin*"]
    man.install "man1"
  end

  test do
    system bin"pdfjam", "-h"
  end
end