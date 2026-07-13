class Pkgconf < Formula
  desc "Package compiler and linker metadata toolkit"
  homepage "https://github.com/pkgconf/pkgconf"
  url "https://distfiles.ariadne.space/pkgconf/pkgconf-3.0.1.tar.xz"
  mirror "https://fossies.org/linux/misc/pkgconf-3.0.1.tar.xz"
  mirror "http://fresh-center.net/linux/misc/pkgconf-3.0.1.tar.xz"
  sha256 "640b0d03a6d9e385d8bdcdac071a5cdf5fbd3f45942d454b711ae46271489b30"
  license "ISC"
  compatibility_version 2

  livecheck do
    url "https://distfiles.ariadne.space/pkgconf/"
    regex(/href=.*?pkgconf[._-]v?(\d+\.\d+(?:\.[1-8]?\d(?:\.\d+)*)?)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "246aa69bcc0db7b8961dac4f74a6923afdf9f1ad2c7c0dc2d560baa4cc55ce2c"
    sha256 arm64_sequoia: "7de336c797cb0f34271a1d618bc4142a49ccd58959899857cbe2d1cdd9351a35"
    sha256 arm64_sonoma:  "84103a43a8d217b4c602f6557c4c342b8b44543bc61d3a7b70ebfb79632688ad"
    sha256 tahoe:         "4807422a17279e810ddcd67a4e2ba4722d4650d37f92e29c7101b44fcdc4fa57"
    sha256 sequoia:       "d68a1366437674482d62af4331e52a5539c16b48d031e5c777fee2209f998bba"
    sha256 sonoma:        "992d06d76e2c25f3f71044f248d8a8aa03a00ca345ebf154a62bc8e210efe38d"
    sha256 arm64_linux:   "0caeacc90f326f3257a139ffb95dde19ad1e093eb56096a3562257377a198340"
    sha256 x86_64_linux:  "9b82434413217540aa036e6bc8465c639a68182772507aa310e6e99a957b4293"
  end

  head do
    url "https://github.com/pkgconf/pkgconf.git", branch: "main"

    # Using a resource to avoiding dependency tree from brew `meson` or `muon`.
    # The version should align to available HTTP mirror rather than latest.
    resource "muon" do
      url "https://muon.build/releases/v0.5.0/muon-v0.5.0.tar.gz"
      mirror "https://deb.debian.org/debian/pool/main/m/muon-meson/muon-meson_0.5.0.orig.tar.gz"
      mirror "http://deb.debian.org/debian/pool/main/m/muon-meson/muon-meson_0.5.0.orig.tar.gz"
      sha256 "24aa4d29ed272893f6e6d355b1ec4ef20647438454e88161bdb9defd7c6faf77"

      livecheck do
        url "https://deb.debian.org/debian/pool/main/m/muon-meson/"
        regex(/href=.*?muon-meson[._-]v?(\d+(?:\.\d+)+)\.orig\.t/i)
      end
    end
  end

  def install
    pc_path = %W[
      #{HOMEBREW_PREFIX}/lib/pkgconfig
      #{HOMEBREW_PREFIX}/share/pkgconfig
    ]
    pc_path += if OS.mac?
      %W[
        /usr/local/lib/pkgconfig
        /usr/lib/pkgconfig
        #{HOMEBREW_LIBRARY}/Homebrew/os/mac/pkgconfig/#{MacOS.version}
      ]
    else
      ["#{HOMEBREW_LIBRARY}/Homebrew/os/linux/pkgconfig"]
    end

    if build.head?
      # Autotools build is planned for removal in pkgconf 3.1
      resource("muon").stage do
        args = ["-Dauto_features=disabled"]
        system "./bootstrap.sh", "build"
        system "build/muon-bootstrap", "meson", "setup", "build", *args, *std_meson_args(prefix: buildpath/"muon")
        system "build/muon-bootstrap", "-C", "build", "samu"
        system "build/muon", "-C", "build", "install"
        ENV.prepend_path "PATH", buildpath/"muon/bin"
      end

      args = %W[
        -Dwith-pkg-config-dir=#{pc_path.uniq.join(File::PATH_SEPARATOR)}
        -Dwith-system-includedir=#{MacOS.sdk_path if OS.mac?}/usr/include
        -Dwith-system-libdir=/usr/lib
      ]

      system "muon", "meson", "setup", "build", *args, *std_meson_args
      system "muon", "-C", "build", "samu"
      system "muon", "-C", "build", "install"
    else
      args = %W[
        --disable-silent-rules
        --with-pkg-config-dir=#{pc_path.uniq.join(File::PATH_SEPARATOR)}
        --with-system-includedir=#{MacOS.sdk_path if OS.mac?}/usr/include
        --with-system-libdir=/usr/lib
      ]

      system "./configure", *args, *std_configure_args
      system "make"
      system "make", "install"
    end

    # Make `pkgconf` a drop-in replacement for `pkg-config` by adding symlink[^1].
    # Similar to Debian[^2], Fedora, ArchLinux and MacPorts.
    #
    # [^1]: https://github.com/pkgconf/pkgconf/#pkg-config-symlink
    # [^2]: https://salsa.debian.org/debian/pkgconf/-/blob/debian/unstable/debian/pkgconf.links?ref_type=heads
    bin.install_symlink "pkgconf" => "pkg-config"
    man1.install_symlink "pkgconf.1" => "pkg-config.1"
  end

  test do
    (testpath/"foo.pc").write <<~PC
      prefix=/usr
      exec_prefix=${prefix}
      includedir=${prefix}/include
      libdir=${exec_prefix}/lib

      Name: foo
      Description: The foo library
      Version: 1.0.0
      Cflags: -I${includedir}/foo
      Libs: -L${libdir} -lfoo
    PC

    ENV["PKG_CONFIG_LIBDIR"] = testpath
    system bin/"pkgconf", "--validate", "foo"
    assert_equal "1.0.0", shell_output("#{bin}/pkgconf --modversion foo").strip
    assert_equal "-lfoo", shell_output("#{bin}/pkgconf --libs-only-l foo").strip
    assert_equal "-I/usr/include/foo", shell_output("#{bin}/pkgconf --cflags foo").strip

    (testpath/"test.c").write <<~C
      #include <assert.h>
      #include <libpkgconf/libpkgconf.h>

      int main(void) {
        assert(pkgconf_compare_version(LIBPKGCONF_VERSION_STR, LIBPKGCONF_VERSION_STR) == 0);
        return 0;
      }
    C

    system ENV.cc, "test.c", "-I#{include}/pkgconf", "-L#{lib}", "-lpkgconf"
    system "./a.out"

    # Make sure system-libdir is removed as it can cause problems in superenv
    if OS.mac?
      ENV.delete "PKG_CONFIG_LIBDIR"
      refute_match "-L/usr/lib", shell_output("#{bin}/pkgconf --libs libcurl")
    end
  end
end