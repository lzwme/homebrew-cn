class Zimg < Formula
  desc "Scaling, colorspace conversion, and dithering library"
  homepage "https://github.com/sekrit-twc/zimg"
  url "https://ghproxy.com/https://github.com/sekrit-twc/zimg/archive/release-3.0.5.tar.gz"
  sha256 "a9a0226bf85e0d83c41a8ebe4e3e690e1348682f6a2a7838f1b8cbff1b799bcf"
  license "WTFPL"
  head "https://github.com/sekrit-twc/zimg.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "cc82dc203d39c81808f2afacf64b5b5048859de941fff9e8caea599b8db83a3f"
    sha256 cellar: :any,                 arm64_monterey: "2bbd044c345af191083c75e1e67b48f31ded8bc4869e19de25d6bd19d3a214ed"
    sha256 cellar: :any,                 arm64_big_sur:  "10507ec0d32970c00e04b4e76714ea452d22f315fdd116af5d56c3d81a7e1f39"
    sha256 cellar: :any,                 ventura:        "31d345c4d6927d6a5f5e1d04b8d78a53db597309c24d301bd0963afcc0702c35"
    sha256 cellar: :any,                 monterey:       "5a8049c1c8fa6e09f79dda6e18ec22909da4b4b567e7f52d4e6338f7ac6dfa64"
    sha256 cellar: :any,                 big_sur:        "5cabd4f2485ba7bb49feecac4584afaa7f05e097cb3935d7e9ea8a06336b4bcf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a33e194d2d9132c9c35d9cb9affc078e77e26a6c8c11fd5b015c6f28914c52fe"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <assert.h>
      #include <zimg.h>

      int main()
      {
        zimg_image_format format;
        zimg_image_format_default(&format, ZIMG_API_VERSION);
        assert(ZIMG_MATRIX_UNSPECIFIED == format.matrix_coefficients);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lzimg", "-o", "test"
    system "./test"
  end
end