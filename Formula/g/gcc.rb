class Gcc < Formula
  desc "GNU compiler collection"
  homepage "https:gcc.gnu.org"
  license "GPL-3.0-or-later" => { with: "GCC-exception-3.1" }
  revision 1
  head "https:gcc.gnu.orggitgcc.git", branch: "master"

  stable do
    url "https:ftp.gnu.orggnugccgcc-14.1.0gcc-14.1.0.tar.xz"
    mirror "https:ftpmirror.gnu.orggccgcc-14.1.0gcc-14.1.0.tar.xz"
    sha256 "e283c654987afe3de9d8080bc0bd79534b5ca0d681a73a11ff2b5d3767426840"

    # Branch from the Darwin maintainer of GCC, with a few generic fixes and
    # Apple Silicon support, located at https:github.comiainsgcc-14-branch
    patch do
      url "https:raw.githubusercontent.comHomebrewformula-patches82b5c1cd38826ab67ac7fc498a8fe74376a40f4agccgcc-14.1.0.diff"
      sha256 "1529cff128792fe197ede301a81b02036c8168cb0338df21e4bc7aafe755305a"
    end

    # Addition patch to be more portable across various SDK headers
    patch do
      url "https:github.comiainsgcc-14-branchcommit75ff8c390327ac693f6a1c40510bc0d35d7a1e22.patch?full_index=1"
      sha256 "13a7ef21fafa39b268e63c3aaed6a78a1d744176a08ffb8d0fbf2f0083e0c850"
    end
  end

  livecheck do
    url :stable
    regex(%r{href=["']?gcc[._-]v?(\d+(?:\.\d+)+)(?:?["' >]|\.t)}i)
  end

  bottle do
    sha256                               arm64_sonoma:   "55d0308e8b18062a65b5e021b0d2378bfa59ce00f1aab168692bacce2309d7c3"
    sha256                               arm64_ventura:  "d392d25a2843f698a4a9b28264b0797759b94d6b617af829c345e6c35513bd47"
    sha256                               arm64_monterey: "ed9b9cdb77ab2125576ee83995f67a0ad652d2a60eb492d143352fa65e79941b"
    sha256                               sonoma:         "2e0a345d1d9730af4ff668daebeb8e7477175f1a18f6b83446a88944cf3a6dd7"
    sha256                               ventura:        "ad8d000ac673d10434c1c12b945c707115536cb6ef8437780fae92b087b5b53b"
    sha256                               monterey:       "eb2742da4807117169cf733f69b0eabfa514347c510067686c58f03971124c2a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6356fd3788f92d60a10ed20cd6b1ec4f4d53235ece41bb7d8678707fabcbfdb1"
  end

  # The bottles are built on systems with the CLT installed, and do not work
  # out of the box on Xcode-only systems due to an incorrect sysroot.
  pour_bottle? only_if: :clt_installed

  depends_on "gmp"
  depends_on "isl"
  depends_on "libmpc"
  depends_on "mpfr"
  depends_on "zstd"

  uses_from_macos "zlib"

  on_linux do
    depends_on "binutils"
  end

  # GCC bootstraps itself, so it is OK to have an incompatible C++ stdlib
  cxxstdlib_check :skip

  def version_suffix
    if build.head?
      "HEAD"
    else
      version.major.to_s
    end
  end

  def install
    # GCC will suffer build errors if forced to use a particular linker.
    ENV.delete "LD"

    # We avoiding building:
    #  - Ada and D, which require a pre-existing GCC to bootstrap
    #  - Go, currently not supported on macOS
    #  - BRIG
    languages = %w[c c++ objc obj-c++ fortran]

    pkgversion = "Homebrew GCC #{pkg_version} #{build.used_options*" "}".strip

    # Use `libgcccurrent` to provide a path that doesn't change with GCC's version.
    args = %W[
      --prefix=#{opt_prefix}
      --libdir=#{opt_lib}gcccurrent
      --disable-nls
      --enable-checking=release
      --with-gcc-major-version-only
      --enable-languages=#{languages.join(",")}
      --program-suffix=-#{version_suffix}
      --with-gmp=#{Formula["gmp"].opt_prefix}
      --with-mpfr=#{Formula["mpfr"].opt_prefix}
      --with-mpc=#{Formula["libmpc"].opt_prefix}
      --with-isl=#{Formula["isl"].opt_prefix}
      --with-zstd=#{Formula["zstd"].opt_prefix}
      --with-pkgversion=#{pkgversion}
      --with-bugurl=#{tap.issues_url}
      --with-system-zlib
    ]

    if OS.mac?
      cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
      args << "--build=#{cpu}-apple-darwin#{OS.kernel_version.major}"

      # System headers may not be in usrinclude
      sdk = MacOS.sdk_path_if_needed
      args << "--with-sysroot=#{sdk}" if sdk

      make_args = []
    else
      # Fix cc1: error while loading shared libraries: libisl.so.15
      args << "--with-boot-ldflags=-static-libstdc++ -static-libgcc #{ENV.ldflags}"

      # Fix Linux error: gnustubs-32.h: No such file or directory.
      args << "--disable-multilib"

      # Enable to PIE by default to match what the host GCC uses
      args << "--enable-default-pie"

      # Change the default directory name for 64-bit libraries to `lib`
      # https:stackoverflow.coma54038769
      inreplace "gccconfigi386t-linux64", "m64=..lib64", "m64="

      make_args = %W[
        BOOT_CFLAGS=-I#{Formula["zlib"].opt_include}
        BOOT_LDFLAGS=-L#{Formula["zlib"].opt_lib}
      ]
    end

    mkdir "build" do
      system "..configure", *args
      system "make", *make_args

      # Do not strip the binaries on macOS, it makes them unsuitable
      # for loading plugins
      install_target = OS.mac? ? "install" : "install-strip"

      # To make sure GCC does not record cellar paths, we configure it with
      # opt_prefix as the prefix. Then we use DESTDIR to install into a
      # temporary location, then move into the cellar path.
      system "make", install_target, "DESTDIR=#{Pathname.pwd}..instdir"
      mv Dir[Pathname.pwd"..instdir#{opt_prefix}*"], prefix
    end

    bin.install_symlink bin"gfortran-#{version_suffix}" => "gfortran"

    # Provide a `libgccxy` directory to align with the versioned GCC formulae.
    # We need to create `libgccxy` as a directory and not a symlink to avoid `brew link` conflicts.
    (lib"gcc"version_suffix).install_symlink (lib"gcccurrent").children

    # Only the newest brewed gcc should install gfortan libs as we can only have one.
    lib.install_symlink lib.glob("gcccurrentlibgfortran.*") if OS.linux?

    # Handle conflicts between GCC formulae and avoid interfering
    # with system compilers.
    # Rename man7.
    man7.glob("*.7") { |file| add_suffix file, version_suffix }
    # Even when we disable building info pages some are still installed.
    info.rmtree

    # Work around GCC install bug
    # https:gcc.gnu.orgbugzillashow_bug.cgi?id=105664
    rm_rf bin.glob("*-gcc-tmp")
  end

  def add_suffix(file, suffix)
    dir = File.dirname(file)
    ext = File.extname(file)
    base = File.basename(file, ext)
    File.rename file, "#{dir}#{base}-#{suffix}#{ext}"
  end

  def post_install
    if OS.linux?
      gcc = bin"gcc-#{version_suffix}"
      libgcc = Pathname.new(Utils.safe_popen_read(gcc, "-print-libgcc-file-name")).parent
      raise "command failed: #{gcc} -print-libgcc-file-name" if $CHILD_STATUS.exitstatus.nonzero?

      glibc = Formula["glibc"]
      glibc_installed = glibc.any_version_installed?

      # Symlink system crt1.o and friends where gcc can find it.
      crtdir = if glibc_installed
        glibc.opt_lib
      else
        Pathname.new(Utils.safe_popen_read("usrbincc", "-print-file-name=crti.o")).parent
      end
      ln_sf Dir[crtdir"*crt?.o"], libgcc

      # Create the GCC specs file
      # See https:gcc.gnu.orgonlinedocsgccSpec-Files.html

      # Locate the specs file
      specs = libgcc"specs"
      ohai "Creating the GCC specs file: #{specs}"
      specs_orig = Pathname.new("#{specs}.orig")
      rm_f [specs_orig, specs]

      system_header_dirs = ["#{HOMEBREW_PREFIX}include"]

      if glibc_installed
        # https:github.comLinuxbrewbrewissues724
        system_header_dirs << glibc.opt_include
      else
        # Locate the native system header dirs if user uses system glibc
        target = Utils.safe_popen_read(gcc, "-print-multiarch").chomp
        raise "command failed: #{gcc} -print-multiarch" if $CHILD_STATUS.exitstatus.nonzero?

        system_header_dirs += ["usrinclude#{target}", "usrinclude"]
      end

      # Save a backup of the default specs file
      specs_string = Utils.safe_popen_read(gcc, "-dumpspecs")
      raise "command failed: #{gcc} -dumpspecs" if $CHILD_STATUS.exitstatus.nonzero?

      specs_orig.write specs_string

      # Set the library search path
      # For include path:
      #   * `-isysroot #{HOMEBREW_PREFIX}nonexistent` prevents gcc searching built-in
      #     system header files.
      #   * `-idirafter <dir>` instructs gcc to search system header
      #     files after gcc internal header files.
      # For libraries:
      #   * `-nostdlib -L#{libgcc} -L#{glibc.opt_lib}` instructs gcc to use
      #     brewed glibc if applied.
      #   * `-L#{libdir}` instructs gcc to find the corresponding gcc
      #     libraries. It is essential if there are multiple brewed gcc
      #     with different versions installed.
      #     Noted that it should only be passed for the `gcc@*` formulae.
      #   * `-L#{HOMEBREW_PREFIX}lib` instructs gcc to find the rest
      #     brew libraries.
      # Note: *link will silently add #{libdir} first to the RPATH
      libdir = HOMEBREW_PREFIX"libgcccurrent"
      specs.write specs_string + <<~EOS
        *cpp_unique_options:
        + -isysroot #{HOMEBREW_PREFIX}nonexistent #{system_header_dirs.map { |p| "-idirafter #{p}" }.join(" ")}

        *link_libgcc:
        #{glibc_installed ? "-nostdlib -L#{libgcc} -L#{glibc.opt_lib}" : "+"} -L#{libdir} -L#{HOMEBREW_PREFIX}lib

        *link:
        + --dynamic-linker #{HOMEBREW_PREFIX}libld.so -rpath #{libdir}

        *homebrew_rpath:
        -rpath #{HOMEBREW_PREFIX}lib

      EOS
      inreplace(specs, " %o ", "\\0%(homebrew_rpath) ")
    end
  end

  test do
    (testpath"hello-c.c").write <<~EOS
      #include <stdio.h>
      int main()
      {
        puts("Hello, world!");
        return 0;
      }
    EOS
    system "#{bin}gcc-#{version_suffix}", "-o", "hello-c", "hello-c.c"
    assert_equal "Hello, world!\n", shell_output(".hello-c")

    (testpath"hello-cc.cc").write <<~EOS
      #include <iostream>
      struct exception { };
      int main()
      {
        std::cout << "Hello, world!" << std::endl;
        try { throw exception{}; }
          catch (exception) { }
          catch (...) { }
        return 0;
      }
    EOS
    system "#{bin}g++-#{version_suffix}", "-o", "hello-cc", "hello-cc.cc"
    assert_equal "Hello, world!\n", shell_output(".hello-cc")

    (testpath"test.f90").write <<~EOS
      integer,parameter::m=10000
      real::a(m), b(m)
      real::fact=0.5

      do concurrent (i=1:m)
        a(i) = a(i) + fact*b(i)
      end do
      write(*,"(A)") "Done"
      end
    EOS
    system "#{bin}gfortran", "-o", "test", "test.f90"
    assert_equal "Done\n", shell_output(".test")
  end
end