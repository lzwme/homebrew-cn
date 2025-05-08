# see https:github.comFLEWID-ABhomebrew-pdfjamblobmasterpdfjam.rb for reference
class Pdfjam < Formula
  desc "Package for manipulating PDF files"
  homepage "https:github.comrrthomaspdfjam"
  url "https:github.comrrthomaspdfjamreleasesdownloadv4.2pdfjam-4.2.tar.gz"
  sha256 "528d7b2eec8461b9ee9cea1d06a117c7ecfa306cf1191d09d64419122464dd89"
  license "GPL-2.0-or-later"

  def install
    bin.install Dir["bin*"]
    man.install "man1"
  end

  test do
    system bin"pdfjam", "-h"
  end
end