class Algol68g < Formula
  desc "Algol 68 compiler-interpreter"
  homepage "https://jmvdveer.home.xs4all.nl/algol.html"
  url "https://jmvdveer.home.xs4all.nl/algol68g-3.5.11.tar.gz"
  sha256 "7ccde50c37033a23f7eedb6cc891fe20e39ead711d5d2ceefb756d82a9c33ddc"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://jmvdveer.home.xs4all.nl/en.download.algol-68-genie-current.html"
    regex(/href=.*?algol68g[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "072368e1851c218e05766f8c72070ecb1abbe8bcd78f58acbdfe5b571260ce73"
    sha256 arm64_sonoma:  "ea5e1343c006934faee9ccddfdf36047f0ada72c976885570db384201471da2c"
    sha256 arm64_ventura: "d9314c4ed75fce1ab2e06e3286241bfbbb1fc31d01026879431c6debbe2f61d9"
    sha256 sonoma:        "e912e88e6e04e2649697521f7feb403af92ec7476be04dbc58fb12c456c0bd34"
    sha256 ventura:       "033adb824628a5f145380d2d0868c8bb8f0cbf0fbbe9b1506c1b43946f33e8be"
    sha256 x86_64_linux:  "2c565141037575809625b41da11f4b06f60d1f691a07a3a21f25ff572c18137b"
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