class Algol68g < Formula
  desc "Algol 68 compiler-interpreter"
  homepage "https://jmvdveer.home.xs4all.nl/algol.html"
  url "https://jmvdveer.home.xs4all.nl/algol68g-3.10.3.tar.gz"
  sha256 "d4bea485d70eb62d9ba26b3d57826118cba628f2bfe939bdb8032e267bfcf1b8"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://jmvdveer.home.xs4all.nl/en.download.algol-68-genie-current.html"
    regex(/href=.*?algol68g[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "e48ae4570069b81916dc48b36a4d1f47dcdf2dbff2542f37604d09c5053d818c"
    sha256 arm64_sequoia: "926adc75b56541bfac5b363fe84f132b2d3ff79c972691e4a0dacb9a6f7a5580"
    sha256 arm64_sonoma:  "f2faa35bdd2764dc0c3f4bdb277298cdcda5ee2f811f1c512e3a88f119533f9d"
    sha256 sonoma:        "e31674ce331185e5536eebce557c541086e505bd6d1d973f185dbab1b6875f95"
    sha256 arm64_linux:   "d8a93267f539c7dfda24214fec0b2eec03d93eac7a468ba2ac194eb3f2c70228"
    sha256 x86_64_linux:  "cf2291af82b2947da8e32b06f3d4f88430850be99a1c2a973bec67c662b5f05b"
  end

  uses_from_macos "ncurses"

  on_linux do
    depends_on "libpq"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    path = testpath/"hello.alg"
    path.write <<~EOS
      print("Hello World")
    EOS

    assert_equal "Hello World", shell_output("#{bin}/a68g #{path}").strip
  end
end