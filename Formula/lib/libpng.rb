class Libpng < Formula
  desc "Library for manipulating PNG images"
  homepage "http://www.libpng.org/pub/png/libpng.html"
  url "https://downloads.sourceforge.net/project/libpng/libpng16/1.6.53/libpng-1.6.53.tar.xz"
  mirror "https://sourceforge.mirrorservice.org/l/li/libpng/libpng16/1.6.53/libpng-1.6.53.tar.xz"
  sha256 "1d3fb8ccc2932d04aa3663e22ef5ef490244370f4e568d7850165068778d98d4"
  license "libpng-2.0"

  livecheck do
    url :stable
    regex(%r{url=.*?/libpng[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "eca4924a22d83e3ccdee21f3d54e5370cb691ff90659402189a54258618dc8e2"
    sha256 cellar: :any,                 arm64_sequoia: "9be8313689149a8cc6623088b1140dac0ff9cf529f5dfde84f2d160a1b0ef588"
    sha256 cellar: :any,                 arm64_sonoma:  "94405130a3d82ced17b97585f36171fe811600f692758d8da3fc7dac48a9be85"
    sha256 cellar: :any,                 sonoma:        "74a8f9da8a81eca68dee3a5db2f5db4f1ba2f460d7a0f9961786fc10b29f163f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0bfc841433eedc64cf64c838fbe3d8b3c54f667e43325f6511aecf35b2ec8ea5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e6f6b36b4272633f7fa5be109719410df8d71814634a21e07509a605af1ee360"
  end

  head do
    url "https://github.com/glennrp/libpng.git", branch: "libpng16"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  uses_from_macos "zlib"

  def install
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make"
    system "make", "test"
    system "make", "install"

    # Avoid rebuilds of dependants that hardcode this path.
    inreplace lib/"pkgconfig/libpng.pc", prefix, opt_prefix
  end

  test do
    (testpath/"test.c").write <<~C
      #include <png.h>

      int main()
      {
        png_structp png_ptr;
        png_ptr = png_create_write_struct(PNG_LIBPNG_VER_STRING, NULL, NULL, NULL);
        png_destroy_write_struct(&png_ptr, (png_infopp)NULL);
        return 0;
      }
    C
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lpng", "-o", "test"
    system "./test"
  end
end