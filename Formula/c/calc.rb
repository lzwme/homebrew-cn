class Calc < Formula
  desc "Arbitrary precision calculator"
  homepage "http://www.isthe.com/chongo/tech/comp/calc/"
  url "https://ghfast.top/https://github.com/lcn2/calc/archive/refs/tags/v2.16.0.3.tar.gz"
  sha256 "8235ae81622bc86b5abe4d922610575e3a7653bff5f8f9be5f918ed7bf8d5857"
  license "LGPL-2.1-or-later"
  head "https://github.com/lcn2/calc.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_tahoe:   "1f25c5cf2be18583c2efb5398201e364d78924d3e7844533be579e318029d535"
    sha256 arm64_sequoia: "d5b454444ffa2a0bd1612918e5f3f15c9444fbe0431127dc18f9f1268a5e85db"
    sha256 arm64_sonoma:  "1bce935da138101d2b98db52d19833bddbd3c8a35fd7fc5ddd519b6bf18ad8da"
    sha256 sonoma:        "f13c2c7e1e6513065c4e833f664cfd29514e341edeac14ca3e76f87bca3750e6"
    sha256 arm64_linux:   "3c76aeabbbad915bf540ba7c28cc1560b5145b1f238d30a416454b4b33d91e62"
    sha256 x86_64_linux:  "2c1c0693a263b34967b55312ce6e4253334c7b1a09dcaead1005cbf205ce2bf5"
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