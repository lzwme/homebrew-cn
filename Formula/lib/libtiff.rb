class Libtiff < Formula
  desc "TIFF library and utilities"
  homepage "https://libtiff.gitlab.io/libtiff/"
  url "https://download.osgeo.org/libtiff/tiff-4.7.2.tar.gz"
  mirror "https://fossies.org/linux/misc/tiff-4.7.2.tar.gz"
  sha256 "672bd7d10aee4606171afb864f3570b83340f6a33e2c186dc0512f7145ffdf6a"
  license "libtiff"
  compatibility_version 1

  livecheck do
    url "https://download.osgeo.org/libtiff/"
    regex(/href=.*?tiff[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "38f4a84e4a689a065991a7f2445563fa38306f9bdd6a27e2c60b33bf11a7d614"
    sha256 cellar: :any, arm64_sequoia: "4763593f3946224d73a9540bd6abc3d798e61dacbbd74acfb4aa1986b3ec66ae"
    sha256 cellar: :any, arm64_sonoma:  "07bf8c9c3339433121c5649182a31f000410ecb1d999ff9d1cda26401b964f9e"
    sha256 cellar: :any, sonoma:        "1988a75c176e06617a0d1187adcef52167e4fff730454dd7e10fabf5add1a30a"
    sha256 cellar: :any, arm64_linux:   "98bf7b3df615c9c72af6161c0afcaaad9f3e34b9ef3d56b7974592b88c10ab04"
    sha256 cellar: :any, x86_64_linux:  "b51ddd5a70047be6391456ccede227826a111e9fffe8ee7541f5200ee969116e"
  end

  depends_on "jpeg-turbo"
  depends_on "xz"
  depends_on "zstd"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    args = %W[
      --disable-libdeflate
      --disable-webp
      --enable-zstd
      --enable-lzma
      --with-jpeg-include-dir=#{formula_opt_include("jpeg-turbo")}
      --with-jpeg-lib-dir=#{formula_opt_lib("jpeg-turbo")}
      --without-x
    ]
    system "./configure", *args, *std_configure_args
    system "make", "install"

    # Avoid rebuilding dependents that hard-code the prefix.
    inreplace lib/"pkgconfig/libtiff-4.pc", prefix, opt_prefix
  end

  test do
    (testpath/"test.c").write <<~C
      #include <tiffio.h>

      int main(int argc, char* argv[])
      {
        TIFF *out = TIFFOpen(argv[1], "w");
        TIFFSetField(out, TIFFTAG_IMAGEWIDTH, (uint32) 10);
        TIFFClose(out);
        return 0;
      }
    C
    system ENV.cc, "test.c", "-L#{lib}", "-ltiff", "-o", "test"
    system "./test", "test.tif"
    assert_match(/ImageWidth.*10/, shell_output("#{bin}/tiffdump test.tif"))
  end
end