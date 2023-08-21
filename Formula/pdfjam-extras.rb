class PdfjamExtras < Formula
  desc "Wrapper scripts for pdfjam"
  homepage "https://github.com/rrthomas/pdfjam-extras"
  url "https://ghproxy.com/https://github.com/rrthomas/pdfjam-extras/archive/622e03add59db004144c0b41722a09b3b29d6d3e.tar.gz"
  version "2019-11-18"
  sha256 "f78ebba20df8a1c2a2f1ad374b3c5ad9c5e43da707b091767b81c5bdd3670ad8"
  license "GPL-2.0"
  head "https://github.com/rrthomas/pdfjam-extras.git", branch: "master"

  depends_on "pdfjam"

  def install
    bin.install Dir["bin/*"]
    man.install "man1"
  end

  test do
    system "#{bin}/pdfnup", "-h"
  end
end