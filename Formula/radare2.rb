class Radare2 < Formula
  desc "Reverse engineering framework"
  homepage "https://radare.org"
  url "https://ghproxy.com/https://github.com/radareorg/radare2/archive/5.8.2.tar.gz"
  sha256 "5eda401bc67e8753ced9813bd66e657d86e56286abe168c12e92edc7dfdb7dbe"
  license "LGPL-3.0-only"
  head "https://github.com/radareorg/radare2.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_ventura:  "c7c80714ba9d80c75202ef7ff313fb9544c76f76dfc440e02079715e0080e67d"
    sha256 arm64_monterey: "79ba219edf427e290c3ba1640f6b4c6d3441fbbe9cc0d7b3d079783807a1257e"
    sha256 arm64_big_sur:  "231e7db80ee37567f546c8c6d80a84d43ee3431529b5148cf0730a6797b942d4"
    sha256 ventura:        "b4c136defd6e076c2245893f0f71ddf9eb1f9ca8c72ecf4b7dbaf3d5bfe8c9e8"
    sha256 monterey:       "6018b73d8eba4ec8deda3d15708f20d8d300d0f96d36e0425ef6eb7675718325"
    sha256 big_sur:        "8bb7e0bd472ecbd1d61194a8ddbaa502ab97851af2c0110e19b9d0077974e29f"
    sha256 x86_64_linux:   "9fc987fd1511a688ab159e33a3a08742e4b6bdd3b5bcbe7efbeed2e6d0f448a7"
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