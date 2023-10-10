class Algol68g < Formula
  desc "Algol 68 compiler-interpreter"
  homepage "https://jmvdveer.home.xs4all.nl/algol.html"
  url "https://jmvdveer.home.xs4all.nl/algol68g-3.4.1.tar.gz"
  sha256 "72393633f19d75cbdf6700ee66d5dd5d205687295a100f5396382296f62604b8"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://jmvdveer.home.xs4all.nl/en.download.algol-68-genie-current.html"
    regex(/href=.*?algol68g[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "b122e3788f41569336b24f412868666722353e01d4cc1c5678b9c755c2abf480"
    sha256 arm64_ventura:  "4942309d1c9fda1166702054c4899477a1a3ed3ef52aea87440370eb18016e25"
    sha256 arm64_monterey: "335930d1f66212efaafa4677a09100cc228846b7b0b9cb792794a910f06e1b45"
    sha256 sonoma:         "59b9bbca3e074f1b0f0e7cceb13636a5fcd08080c03fc810b6d285bf5f6d2b53"
    sha256 ventura:        "5d9a3f097fbb8cbb88f836229c3887ba686b5fca6e198438047746f1703e093b"
    sha256 monterey:       "7b4333625e0a6112912cd4276945697bfb91089b8df2076edca8ebfa8ae82afd"
    sha256 x86_64_linux:   "6109755e7ac6cb0912bed1edf0bedf07204c8aa819182eaaf0fbf24591b5078f"
  end

  on_linux do
    depends_on "libpq"
  end

  def install
    # Fix compile with newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

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