class Calc < Formula
  desc "Arbitrary precision calculator"
  homepage "http://www.isthe.com/chongo/tech/comp/calc/"
  url "https://ghfast.top/https://github.com/lcn2/calc/archive/refs/tags/v2.16.0.2.tar.gz"
  sha256 "2beedbf40eedea431b765b37e39e1a7e2aa35bfde4136694800e4149074b1b53"
  license "LGPL-2.1-or-later"
  head "https://github.com/lcn2/calc.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_tahoe:   "bd1e254d1989f6977033f573e1f1ddf61be476517f243d8ab8e839b868f6104a"
    sha256 arm64_sequoia: "b153be75bc10456efcf51a98d4512d83e1c87c7eeeef1fef2f16dfb3467e4997"
    sha256 arm64_sonoma:  "4e35948668aab1b66012d6455a694b5babbb6da2830d25dacc8ddb5ebc9e3de2"
    sha256 sonoma:        "9ddf82a49ae71ea8c450a08fc4c58fc6496717f387b0e4ede4206c072a0b856e"
    sha256 arm64_linux:   "fbdf5d699f602875da1150f54e791b0a06c7344a277a72037d92a53749d6c3fb"
    sha256 x86_64_linux:  "0207c6127c7f5d7b94d4ba4a6319e8ff2561a174854a6f52c669891360656269"
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