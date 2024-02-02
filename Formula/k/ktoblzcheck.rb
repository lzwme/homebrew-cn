class Ktoblzcheck < Formula
  desc "Library for German banks"
  homepage "https://ktoblzcheck.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/ktoblzcheck/ktoblzcheck-1.53.tar.gz"
  sha256 "18b9118556fe83240f468f770641d2578f4ff613cdcf0a209fb73079ccb70c55"
  license "LGPL-2.1-or-later"
  revision 2

  livecheck do
    url :stable
    regex(%r{url=.*?/ktoblzcheck[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    rebuild 2
    sha256 arm64_sonoma:   "3a363b745e2bc924d9aeb8106bd76a25e6d6316cf9bfc2b5c7973c5b2e0dc9b7"
    sha256 arm64_ventura:  "a1ea0492833ca7d4e223fbf94ff19574d559382389af519b503d61500b85f808"
    sha256 arm64_monterey: "9a3b76b95a852e1141d40552a39ca8746f069e31fefe3d3477541f031bb37cd5"
    sha256 sonoma:         "3b9da96c6831649627880831f4aac40ee80a3034666b34794b5d69b7fdd8dbe2"
    sha256 ventura:        "8c5172ecb224bab53baae044dfdab817e7fbd7876a25939d2f6ac29f57aba39b"
    sha256 monterey:       "944be5e0ff7713ee27ffeca810682fd2d8da35c15c2dcd005335dc95fc8659cd"
    sha256 x86_64_linux:   "b921c327b7507267638b703643ab621322c56deebb4d6d3cba4ae7f3b22e7431"
  end

  depends_on "cmake" => :build
  depends_on "python@3.12"

  # Support python 3.12
  # https://sourceforge.net/p/ktoblzcheck/code/ci/f5973ed2507f22f8d75dbfa81ca5d392683a1406/
  patch :DATA

  def install
    # Work around to help Python bindings find shared library on macOS.
    # OSError: dlopen(ktoblzcheck, 0x0006): tried: 'ktoblzcheck' (no such file), ...
    # OSError: dlopen(libktoblzcheck.so.1, 0x0006): tried: 'libktoblzcheck.so.1' (no such file), ...
    inreplace "src/python/ktoblzcheck.py", /'libktoblzcheck\.so\.(\d+)'/, "'libktoblzcheck.\\1.dylib'" if OS.mac?

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, "-DCMAKE_INSTALL_RPATH=#{opt_lib}"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match "Ok", shell_output("#{bin}/ktoblzcheck --outformat=oneline 10000000 123456789")
    assert_match "unknown", shell_output("#{bin}/ktoblzcheck --outformat=oneline 12345678 100000000", 3)
    system "python3.12", "-c", "import ktoblzcheck"
  end
end

__END__
--- a/src/python/ktoblzcheck.py
+++ b/src/python/ktoblzcheck.py
@@ -41,7 +41,7 @@

 try:
     kto = cdll.ktoblzcheck
-except OSError:
+except (OSError, AttributeError):
     kto = cdll['libktoblzcheck.so.1']