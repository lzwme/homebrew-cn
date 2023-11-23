class Pkgconf < Formula
  desc "Package compiler and linker metadata toolkit"
  homepage "https://github.com/pkgconf/pkgconf"
  url "https://distfiles.ariadne.space/pkgconf/pkgconf-2.1.0.tar.xz"
  sha256 "266d5861ee51c52bc710293a1d36622ae16d048d71ec56034a02eb9cf9677761"
  license "ISC"

  livecheck do
    url "https://distfiles.ariadne.space/pkgconf/"
    regex(/href=.*?pkgconf[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "888ef8939c6feb503056b84ab03017e6741984db9f987f4a62a4291f487abf9c"
    sha256 arm64_ventura:  "083fa666cedc05c8dd5f7fa609013f64ae448201a6a437c7f4368f98a8b7e521"
    sha256 arm64_monterey: "873f14190f5a2bb0272dbe1701c3c0ebe9b796326f5c5726f2061aa4efdad2c9"
    sha256 sonoma:         "c50ba88a017f706dac88216ce57ee89315d0c7b13e93101112bd2950971e12d8"
    sha256 ventura:        "1522392c191a511c4670236293c16d66e6fe94fd82777f6260163036f120c996"
    sha256 monterey:       "db650c3b5811e20d14f548aae082e502caec322b03130322edfc8070e8a96e6c"
    sha256 x86_64_linux:   "30ed3173bb922d766b272b94ab6f6c17c5fcac0c0ab0c2a701fb0b4284bb7ed0"
  end

  head do
    url "https://github.com/pkgconf/pkgconf.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  conflicts_with "pkg-config", because: "both install `pkg.m4` file"

  def install
    if build.head?
      ENV["LIBTOOLIZE"] = "glibtoolize"
      system "./autogen.sh"
    end

    pc_path = %W[
      #{HOMEBREW_PREFIX}/lib/pkgconfig
      #{HOMEBREW_PREFIX}/share/pkgconfig
    ]
    pc_path << if OS.mac?
      pc_path << "/usr/local/lib/pkgconfig"
      pc_path << "/usr/lib/pkgconfig"
      "#{HOMEBREW_LIBRARY}/Homebrew/os/mac/pkgconfig/#{MacOS.version}"
    else
      "#{HOMEBREW_LIBRARY}/Homebrew/os/linux/pkgconfig"
    end

    pc_path = pc_path.uniq.join(File::PATH_SEPARATOR)

    configure_args = std_configure_args + %W[
      --with-pkg-config-dir=#{pc_path}
    ]

    system "./configure", *configure_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"foo.pc").write <<~EOS
      prefix=/usr
      exec_prefix=${prefix}
      includedir=${prefix}/include
      libdir=${exec_prefix}/lib

      Name: foo
      Description: The foo library
      Version: 1.0.0
      Cflags: -I${includedir}/foo
      Libs: -L${libdir} -lfoo
    EOS

    ENV["PKG_CONFIG_LIBDIR"] = testpath
    system bin/"pkgconf", "--validate", "foo"
    assert_equal "1.0.0", shell_output("#{bin}/pkgconf --modversion foo").strip
    assert_equal "-lfoo", shell_output("#{bin}/pkgconf --libs-only-l foo").strip
    assert_equal "-I/usr/include/foo", shell_output("#{bin}/pkgconf --cflags foo").strip

    (testpath/"test.c").write <<~EOS
      #include <assert.h>
      #include <libpkgconf/libpkgconf.h>

      int main(void) {
        assert(pkgconf_compare_version(LIBPKGCONF_VERSION_STR, LIBPKGCONF_VERSION_STR) == 0);
        return 0;
      }
    EOS

    system ENV.cc, "test.c", "-I#{include}/pkgconf", "-L#{lib}", "-lpkgconf"
    system "./a.out"
  end
end