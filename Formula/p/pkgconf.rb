class Pkgconf < Formula
  desc "Package compiler and linker metadata toolkit"
  homepage "https:github.compkgconfpkgconf"
  url "https:distfiles.ariadne.spacepkgconfpkgconf-2.4.0.tar.xz"
  mirror "http:distfiles.ariadne.spacepkgconfpkgconf-2.4.0.tar.xz"
  sha256 "981ba79da1ef30339faf8da9a905d367d94cd618cb028ba9ac402742f39313e5"
  license "ISC"

  livecheck do
    url "https:distfiles.ariadne.spacepkgconf"
    regex(href=.*?pkgconf[._-]v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 arm64_sequoia: "962166ef924ed34d5806c8c345666281e5a60e55ea9a8fd84a59dd3bab020d5f"
    sha256 arm64_sonoma:  "518c4c7ef904ec828e76c09a7c8eefa668866d00cad9d10bd1f767551c50b2c8"
    sha256 arm64_ventura: "2a3b8d8e0686f51c20ed0079fd132f2747b15416970df2c26fb86eb3e7c95c86"
    sha256 sonoma:        "b864ffba1311bd5843b3f709341e5a5aa2a9fa05d5d2212a4694544044116d6d"
    sha256 ventura:       "7199fff663e6ca7a5cf2339a2e650daf3370230a27302347b6eae793aa9314f4"
    sha256 x86_64_linux:  "53ee05448762c74e246705b2f76579ded289324b29b01729b94e1b0acc2b3d8a"
  end

  head do
    url "https:github.compkgconfpkgconf.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  def install
    if build.head?
      ENV["LIBTOOLIZE"] = "glibtoolize"
      system ".autogen.sh"
    end

    pc_path = %W[
      #{HOMEBREW_PREFIX}libpkgconfig
      #{HOMEBREW_PREFIX}sharepkgconfig
    ]
    pc_path += if OS.mac?
      %W[
        usrlocallibpkgconfig
        usrlibpkgconfig
        #{HOMEBREW_LIBRARY}Homebrewosmacpkgconfig#{MacOS.version}
      ]
    else
      ["#{HOMEBREW_LIBRARY}Homebrewoslinuxpkgconfig"]
    end

    args = %W[
      --disable-silent-rules
      --with-pkg-config-dir=#{pc_path.uniq.join(File::PATH_SEPARATOR)}
      --with-system-includedir=#{MacOS.sdk_path_if_needed if OS.mac?}usrinclude
      --with-system-libdir=usrlib
    ]

    system ".configure", *args, *std_configure_args
    system "make"
    system "make", "install"

    # Make `pkgconf` a drop-in replacement for `pkg-config` by adding symlink[^1].
    # Similar to Debian[^2], Fedora, ArchLinux and MacPorts.
    #
    # [^1]: https:github.compkgconfpkgconf#pkg-config-symlink
    # [^2]: https:salsa.debian.orgdebianpkgconf-blobdebianunstabledebianpkgconf.links?ref_type=heads
    bin.install_symlink "pkgconf" => "pkg-config"
    man1.install_symlink "pkgconf.1" => "pkg-config.1"
  end

  test do
    (testpath"foo.pc").write <<~PC
      prefix=usr
      exec_prefix=${prefix}
      includedir=${prefix}include
      libdir=${exec_prefix}lib

      Name: foo
      Description: The foo library
      Version: 1.0.0
      Cflags: -I${includedir}foo
      Libs: -L${libdir} -lfoo
    PC

    ENV["PKG_CONFIG_LIBDIR"] = testpath
    system bin"pkgconf", "--validate", "foo"
    assert_equal "1.0.0", shell_output("#{bin}pkgconf --modversion foo").strip
    assert_equal "-lfoo", shell_output("#{bin}pkgconf --libs-only-l foo").strip
    assert_equal "-Iusrincludefoo", shell_output("#{bin}pkgconf --cflags foo").strip

    (testpath"test.c").write <<~C
      #include <assert.h>
      #include <libpkgconflibpkgconf.h>

      int main(void) {
        assert(pkgconf_compare_version(LIBPKGCONF_VERSION_STR, LIBPKGCONF_VERSION_STR) == 0);
        return 0;
      }
    C

    system ENV.cc, "test.c", "-I#{include}pkgconf", "-L#{lib}", "-lpkgconf"
    system ".a.out"

    # Make sure system-libdir is removed as it can cause problems in superenv
    if OS.mac?
      ENV.delete "PKG_CONFIG_LIBDIR"
      refute_match "-Lusrlib", shell_output("#{bin}pkgconf --libs libcurl")
    end
  end
end