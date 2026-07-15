class Pkgconf < Formula
  desc "Package compiler and linker metadata toolkit"
  homepage "https://github.com/pkgconf/pkgconf"
  url "https://distfiles.ariadne.space/pkgconf/pkgconf-3.0.2.tar.xz"
  mirror "https://fossies.org/linux/misc/pkgconf-3.0.2.tar.xz"
  mirror "http://fresh-center.net/linux/misc/pkgconf-3.0.2.tar.xz"
  sha256 "42ce89ba4c45e6fefaab970bf81d3fadfb738f8d5243460fa67bc4fed84b0db0"
  license "ISC"
  compatibility_version 2

  livecheck do
    url "https://distfiles.ariadne.space/pkgconf/"
    regex(/href=.*?pkgconf[._-]v?(\d+\.\d+(?:\.[1-8]?\d(?:\.\d+)*)?)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "a63df27952ef32832414eadf8164ca8b8b54f9e3717d991e742b8a4e9a9defed"
    sha256 arm64_sequoia: "2591627ade0a51cd06c15ed3efe52718f0580ddcadfda27168172d7aaf5702f6"
    sha256 arm64_sonoma:  "4f94a880116b2d19e8bbff1adb132d7d18911ac6387dacbf69786a40d22ed293"
    sha256 tahoe:         "4ffc1557bc087f33d10ba7ab2343c0b1455db3a78f7d5f3df749abe4601fbc90"
    sha256 sequoia:       "7ce056c34465c850e8105429d028e9d4732a5ca3536f8857988da17a3e9cf0b9"
    sha256 sonoma:        "e94a5661bc1b0791bd69478895e11793a1921142fc9d1b6c0c6723840dc3be3d"
    sha256 arm64_linux:   "8ba68df0804e565ec420b29bafaf3a435a14ff6a347efa4f1b7f984b06257ca4"
    sha256 x86_64_linux:  "1a25d32651b61d16b584292eab33d23bef2b5e190f67ca6832fe226f1ee1f29d"
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