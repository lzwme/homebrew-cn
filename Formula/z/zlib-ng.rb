class ZlibNg < Formula
  desc "Zlib replacement with optimizations for next generation systems"
  homepage "https://github.com/zlib-ng/zlib-ng"
  url "https://ghproxy.com/https://github.com/zlib-ng/zlib-ng/archive/refs/tags/2.1.4.tar.gz"
  sha256 "a0293475e6a44a3f6c045229fe50f69dc0eebc62a42405a51f19d46a5541e77a"
  license "Zlib"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "0f4bf43f0dc661fa7ee3fbc78bc16ecfb9013cb74d1a6d291cac197b05de50da"
    sha256 cellar: :any,                 arm64_ventura:  "91dc965141b58e54b99f9a3da22d79cf9ddee628564778daf20e940e6533c5d0"
    sha256 cellar: :any,                 arm64_monterey: "7f3612cf2f17b43a88eacaeb2d24ed61320eda2c94a3f182dd825369d33473ce"
    sha256 cellar: :any,                 sonoma:         "3271ef7cb31b8774444fd2cf028624bd22059d9dd6a9fa0050e85c3a354422ff"
    sha256 cellar: :any,                 ventura:        "7c93a0f306b23b7d241f5928b3e15d6e4a4a1c77a0ce13448b6bf3cc388fa332"
    sha256 cellar: :any,                 monterey:       "c5e850c8cbad665e2c99841d64a5c42d7e75e038d176368e1bb5b01b39f39400"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5969bec95b8d6854d073add20d820b4e7069bff1ffd8a27f3dae95f0866722b5"
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