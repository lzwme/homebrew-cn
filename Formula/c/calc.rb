class Calc < Formula
  desc "Arbitrary precision calculator"
  homepage "http://www.isthe.com/chongo/tech/comp/calc/"
  url "https://ghfast.top/https://github.com/lcn2/calc/archive/refs/tags/v2.17.0.1.tar.gz"
  sha256 "6fa7e541324bf795c5737a840864858ec47bddbe9d985f367905e74da2c3b290"
  license "LGPL-2.1-or-later"
  head "https://github.com/lcn2/calc.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_golden_gate: "d7a23a3bc9e0b0286950470cf3b5ed539b631c540374c6b188b3cddefaea12ac"
    sha256 arm64_tahoe:       "fb2eca8cdbca62794a1e77361bc6136a29e1e745e5c0ed872ef29ae2bb5bbd9b"
    sha256 arm64_sequoia:     "fe30fd58df941161e5b0f7fa61e2f862ad55f03a8950214c6e9e6d4323a1d9c4"
    sha256 arm64_linux:       "cfa39d480d7a44637ff3abe8b880c973c265aa8ca6fe9b048036c564205a991d"
    sha256 x86_64_linux:      "f75079b41f548b2938109716a575b385018d9bf78870a3c7d1f961641764b214"
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
      "READLINE_LIB=-L#{formula_opt_lib("readline")} -lreadline",
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