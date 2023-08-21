# see https://github.com/FLEWID-AB/homebrew-pdfjam/blob/master/pdfjam.rb for reference
class Pdfjam < Formula
  desc "Package for manipulating PDF files"
  homepage "https://github.com/rrthomas/pdfjam"
  url "https://ghproxy.com/https://github.com/rrthomas/pdfjam/releases/download/v3.07/pdfjam-3.07.tar.gz"
  sha256 "00dcd37db9a7f6246da225be31724faf3616db4f78a3dba521682d54d1e9eba5"
  license "GPL-2.0-or-later"

  def install
    bin.install Dir["bin/*"]
    man.install "man1"
  end

  test do
    system "#{bin}/pdfjam", "-h"
  end
end