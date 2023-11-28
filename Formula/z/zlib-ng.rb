class ZlibNg < Formula
  desc "Zlib replacement with optimizations for next generation systems"
  homepage "https://github.com/zlib-ng/zlib-ng"
  url "https://ghproxy.com/https://github.com/zlib-ng/zlib-ng/archive/refs/tags/2.1.5.tar.gz"
  sha256 "3f6576971397b379d4205ae5451ff5a68edf6c103b2f03c4188ed7075fbb5f04"
  license "Zlib"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "f2eff75765a895759fe65f358e62b0e3f3a658dc8c733cb3a0d1118a8bf7730a"
    sha256 cellar: :any,                 arm64_ventura:  "8fa22d47b4c6bd2e5c0b36af52fb2f3a80ccd861b65b39d0c3b5c12cd7bd3480"
    sha256 cellar: :any,                 arm64_monterey: "c1382fbd14db3fc0b4e0cf73db0d4c7281fc2b918b3b49199392f7051c3c366b"
    sha256 cellar: :any,                 sonoma:         "bdd2ad55d1067a36024ee2a9b29f766484cfbb66227ea1fec341ffbc45983a45"
    sha256 cellar: :any,                 ventura:        "b231bbb0aad346343a1e4ec7ccc5f66636a8defc135e8e2124b4db05cd8da2b7"
    sha256 cellar: :any,                 monterey:       "7d8e46a6db4bde7939ac78f70ec742447f6808ba7fabc9a63760109491fd7672"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "591d6f97690527cad8c7896df332762ee706968ca7baf9136e2ccdb9ab94605d"
  end

  # https://zlib.net/zlib_how.html
  resource "homebrew-test_artifact" do
    url "https://zlib.net/zpipe.c"
    sha256 "68140a82582ede938159630bca0fb13a93b4bf1cb2e85b08943c26242cf8f3a6"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    # Test uses an example of code for zlib and overwrites its API with zlib-ng API
    testpath.install resource("homebrew-test_artifact")
    inreplace "zpipe.c", "#include \"zlib.h\"", <<~EOS
      #include "zlib-ng.h"
      #define inflate     zng_inflate
      #define inflateInit zng_inflateInit
      #define inflateEnd  zng_inflateEnd
      #define deflate     zng_deflate
      #define deflateEnd  zng_deflateEnd
      #define deflateInit zng_deflateInit
      #define z_stream    zng_stream
    EOS

    system ENV.cc, "zpipe.c", "-I#{include}", "-L#{lib}", "-lz-ng", "-o", "zpipe"

    content = "Hello, Homebrew!"
    compressed = pipe_output("./zpipe", content)
    assert_equal content, pipe_output("./zpipe -d", compressed)
  end
end