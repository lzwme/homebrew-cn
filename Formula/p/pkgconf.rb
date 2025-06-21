class Pkgconf < Formula
  desc "Package compiler and linker metadata toolkit"
  homepage "https:github.compkgconfpkgconf"
  url "https:distfiles.ariadne.spacepkgconfpkgconf-2.5.0.tar.xz"
  mirror "http:distfiles.ariadne.spacepkgconfpkgconf-2.5.0.tar.xz"
  sha256 "9f5f5f2d067b1c668d6cfd662791d8aae3ef06c670125601e39f1156bd3f409f"
  license "ISC"

  livecheck do
    url "https:distfiles.ariadne.spacepkgconf"
    regex(href=.*?pkgconf[._-]v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 arm64_sequoia: "fd9e23c224f18006ca873acd92e8e22cbda749cd150ef7516122d394d1655f1f"
    sha256 arm64_sonoma:  "444c2f67483ed4246e7cdcd019947ed6672e7ac79afcee64e344a18735b521ae"
    sha256 arm64_ventura: "f0edc798188e60e0fd82815f0f21b186a0d41310ce71d4aac17411219140bd2e"
    sha256 sequoia:       "ff125cd1355b46cc32f801e9aeac280659b9f67dd4adeebc3c8cbbad6646330d"
    sha256 sonoma:        "2196e245926fbd2fc400b05c67d93d2053de30d7971cda41ad55e11d0d2320c2"
    sha256 ventura:       "45d0102051d02a96394b8b28fa53caa0a4b28af871e1093c0435ccf0ef079971"
    sha256 arm64_linux:   "b23fff3027dc4144931bd826dd148b616574fa15848b60595ee876234d3da495"
    sha256 x86_64_linux:  "4b8ea4a65be2d9ea9f7c4f6ef9fddc182e097d34abf8249f23f54a77924ebe76"
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