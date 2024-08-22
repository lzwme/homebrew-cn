class I2util < Formula
  desc "Internet2 utility tools"
  homepage "https:github.comperfsonari2util"
  url "https:github.comperfsonari2utilarchiverefstagsv5.1.2.tar.gz"
  sha256 "27f86aa2b5f2d08c0ea99412c05764cd1a4953fe4d37e30d550d7d53c3b93c3d"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "568713828868369047a6edb673c19ed723501ee95a22951e5755ef967b3a330c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5180278807727aed98c0f42c553f7b75f93b1ebe9573494e12b7f6a7edbcb33b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2ead09e3b35f362f8828f577927d201260952ff63637ddbc929478f627e32dd9"
    sha256 cellar: :any_skip_relocation, sonoma:         "ea50d9ecd048d84aa63bbba16e65bc31116b2ee0e59f7d3e7a7bd7162c4c4492"
    sha256 cellar: :any_skip_relocation, ventura:        "d4e82541ef2b3a0bf20c2c3658769e92fa7b1a2a5fce6303e09c472081a396bc"
    sha256 cellar: :any_skip_relocation, monterey:       "1c2771b19cc2a3f837b290e515e236c06b551c35b53222d543e1c960ad922ba3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5500ad8f15d515efc6405dcb15d4909ac3baa17a8808f89245d2ad81e45190b0"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  def install
    cd "I2utilI2util" do
      system ".bootstrap"
      system ".configure", "--disable-silent-rules", *std_configure_args
      system "make", "install"
    end
  end

  test do
    (testpath"test.c").write <<~EOS
      #include <I2utilutil.h>
      #include <string.h>

      int main() {
        uint8_t buf[2];
        if (!I2HexDecode("beef", buf, sizeof(buf))) return 1;
        if (buf[0] != 190 || buf[1] != 239) return 1;
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lI2util", "-o", "test"
    system ".test"
  end
end