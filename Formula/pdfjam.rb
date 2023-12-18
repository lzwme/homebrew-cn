# see https:github.comFLEWID-ABhomebrew-pdfjamblobmasterpdfjam.rb for reference
class Pdfjam < Formula
  desc "Package for manipulating PDF files"
  homepage "https:github.comrrthomaspdfjam"
  url "https:github.comrrthomaspdfjamreleasesdownloadv3.10pdfjam-3.10.tar.gz"
  sha256 "a1a2e422949ece10190034283ac5267d1ec160369cbc56b4a524dfdf1adf2310"
  license "GPL-2.0-or-later"

  def install
    bin.install Dir["bin*"]
    man.install "man1"
  end

  test do
    system "#{bin}pdfjam", "-h"
  end
end