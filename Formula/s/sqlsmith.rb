class Sqlsmith < Formula
  desc "Random SQL query generator"
  homepage "https://github.com/anse1/sqlsmith"
  url "https://ghproxy.com/https://github.com/anse1/sqlsmith/releases/download/v1.4/sqlsmith-1.4.tar.gz"
  sha256 "b0821acbe82782f6037315549f475368be3592cefe2c3c540f9cf52aa70d2f55"
  license "GPL-3.0-only"
  revision 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "61cd1b817158ffd26e018f0b09994e32d8369303a05c68060382766f9d8e6bcb"
    sha256 cellar: :any,                 arm64_ventura:  "aff8f6b845037c8ca965e9c60fad6e5b42f22b37fcd9659575ba2d158f006ad5"
    sha256 cellar: :any,                 arm64_monterey: "f8b3b917d636c0277977bc6958b91602e0163e106c686122f94da850643ba050"
    sha256 cellar: :any,                 sonoma:         "99ee3ae1cdb8cbf77dacdeb5e61f009183ba94193d465a7fa1fb1d6fd4d48d76"
    sha256 cellar: :any,                 ventura:        "f00f7712fb9f937f041a82981987937517a0bc9e9b3a1f87b3dab59ed299fed7"
    sha256 cellar: :any,                 monterey:       "f97a4b52e39ac8ddfe109b95107ead14db4965ea0e72dc1136f8782aa088f83c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "46650407158137c26715060d38c7233e0c9f1beeb3995af44a49b4b2997f4ae7"
  end

  head do
    url "https://github.com/anse1/sqlsmith.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "autoconf-archive" => :build # required for AX_CXX_COMPILE_STDCXX_17
    depends_on "automake" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "libpqxx"

  uses_from_macos "sqlite"

  def install
    system "autoreconf", "-fvi" if build.head?
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make"
    system "make", "install"
  end

  test do
    cmd = %W[
      #{bin}/sqlsmith
      --sqlite
      --max-queries=100
      --verbose
      --seed=1
      2>&1
    ].join(" ")
    output = shell_output(cmd)

    assert_match "Loading tables...done.", output
    assert_match "Loading columns and constraints...done.", output
    assert_match "Generating indexes...done.", output
    assert_match "queries: 100", output
    assert_match "impedance report:", output
  end
end