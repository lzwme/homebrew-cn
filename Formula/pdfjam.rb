# see https://github.com/FLEWID-AB/homebrew-pdfjam/blob/master/pdfjam.rb for reference
class Pdfjam < Formula
  desc "Package for manipulating PDF files"
  homepage "https://github.com/rrthomas/pdfjam"
  url "https://ghfast.top/https://github.com/rrthomas/pdfjam/releases/download/v4.2/pdfjam-4.2.tar.gz"
  sha256 "528d7b2eec8461b9ee9cea1d06a117c7ecfa306cf1191d09d64419122464dd89"
  license "GPL-2.0-or-later"

  def install
    bin.install Dir["bin/*"]
    man.install "man1"
  end

  test do
    system bin/"pdfjam", "-h"
  end
end