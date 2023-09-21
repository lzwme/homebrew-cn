# see https://github.com/FLEWID-AB/homebrew-pdfjam/blob/master/pdfjam.rb for reference
class Pdfjam < Formula
  desc "Package for manipulating PDF files"
  homepage "https://github.com/rrthomas/pdfjam"
  url "https://ghproxy.com/https://github.com/rrthomas/pdfjam/releases/download/v3.08/pdfjam-3.08.tar.gz"
  sha256 "e929cd1b562f02640d70bf8e33396843a33b5a064a347c01e589cd5599378b31"
  license "GPL-2.0-or-later"

  def install
    bin.install Dir["bin/*"]
    man.install "man1"
  end

  test do
    system "#{bin}/pdfjam", "-h"
  end
end