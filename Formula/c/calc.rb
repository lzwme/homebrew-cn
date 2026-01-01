class Calc < Formula
  desc "Arbitrary precision calculator"
  homepage "http://www.isthe.com/chongo/tech/comp/calc/"
  url "https://ghfast.top/https://github.com/lcn2/calc/archive/refs/tags/v2.16.1.0.tar.gz"
  sha256 "c88cd68de12ae2a4f728a81a1e57fef7054d16c0a497715336ebc44a533eed54"
  license "LGPL-2.1-or-later"
  head "https://github.com/lcn2/calc.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_tahoe:   "4c6a6be688b6659bda44c234c3014943d2899325b28656139791e3d0871f8f32"
    sha256 arm64_sequoia: "459dd4afff6c62bc60fc26eda9ed1bc496f98b4834a5340c3835e50bc77e8841"
    sha256 arm64_sonoma:  "0bf44220896e0e95f6659176dafc6c120121fc7136a42e83ad8436e011ee0357"
    sha256 sonoma:        "c3fb2c03b1301f7c1812d0b12cd8ac6751e836ee95e8a0e0ba165c1f25872ac3"
    sha256 arm64_linux:   "f2185e35efe60df3f1a0b2dcd20b31b1faab3997077ecc6255b98ba27ab4a830"
    sha256 x86_64_linux:  "8f115bb64ef0d3f0c551b9c32069f15fe7f67590b3993b8dd0d99fbe84b3e294"
  end

  depends_on "readline"

  on_linux do
    depends_on "util-linux" # for `col`
  end

  def install
    ENV.deparallelize

    ENV["EXTRA_CFLAGS"] = ENV.cflags
    ENV["EXTRA_LDFLAGS"] = ENV.ldflags

    args = [
      "BINDIR=#{bin}",
      "LIBDIR=#{lib}",
      "MANDIR=#{man1}",
      "CALC_INCDIR=#{include}/calc",
      "CALC_SHAREDIR=#{pkgshare}",
      "USE_READLINE=-DUSE_READLINE",
      "READLINE_LIB=-L#{Formula["readline"].opt_lib} -lreadline",
      "READLINE_EXTRAS=-lhistory -lncurses",
    ]
    args << "INCDIR=#{MacOS.sdk_path}/usr/include" if OS.mac?
    system "make", "install", *args

    libexec.install "#{bin}/cscript"
  end

  test do
    assert_equal "11", shell_output("#{bin}/calc 0xA + 1").strip
  end
end