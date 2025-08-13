class Radare2 < Formula
  desc "Reverse engineering framework"
  homepage "https://radare.org"
  url "https://ghfast.top/https://github.com/radareorg/radare2/archive/refs/tags/6.0.2.tar.gz"
  sha256 "a9e359c6550da70b2b2a82f1aa1c2bbd0eeb309ea64e418261fc39816e82cf91"
  license "LGPL-3.0-only"
  head "https://github.com/radareorg/radare2.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sequoia: "d43b6bc9afdd4754b1fc905136332999e39a1a25301d5fba6459a745f2651694"
    sha256 arm64_sonoma:  "1969a96a3144de02d1e8163e07be41faa080e6375399806b0fc4649ff515e182"
    sha256 arm64_ventura: "43a6a9dfa0b37be1db83b5c709cd37785d01ba6d8e75d5a15a9acb7c5ec2ab45"
    sha256 sonoma:        "5071ebc90f0087dece4ab6ec2d3e03db7b36170ef3dde1bca0a680f22cf7e5a4"
    sha256 ventura:       "c075f91b1165037159e633266f9a7e189d608097c8a104d735ce1fa7183d8f26"
    sha256 arm64_linux:   "82f22bbce3831dc083e9995842e4ab11999bbfad58e9ee6bdbd23329204637b9"
    sha256 x86_64_linux:  "c058b317aef60a6fb4ff3cdc2677b8c084a57058d0adbb4f7fcb943a11099102"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    assert_match "radare2 #{version}", shell_output("#{bin}/r2 -v")
  end
end