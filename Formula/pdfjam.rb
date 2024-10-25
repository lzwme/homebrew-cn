# see https:github.comFLEWID-ABhomebrew-pdfjamblobmasterpdfjam.rb for reference
class Pdfjam < Formula
  desc "Package for manipulating PDF files"
  homepage "https:github.comrrthomaspdfjam"
  url "https:github.comrrthomaspdfjamreleasesdownloadv3.12pdfjam-3.12.tar.gz"
  sha256 "c8c227d10abd0e787c1c2da290bb5ddb77c19eebfd434649e8cbb2c5152feb31"
  license "GPL-2.0-or-later"

  def install
    bin.install Dir["bin*"]
    man.install "man1"
  end

  test do
    system bin"pdfjam", "-h"
  end
end