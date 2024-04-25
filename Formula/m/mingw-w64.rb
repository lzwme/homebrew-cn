class MingwW64 < Formula
  desc "Minimalist GNU for Windows and GCC cross-compilers"
  homepage "https://sourceforge.net/projects/mingw-w64/"
  url "https://downloads.sourceforge.net/project/mingw-w64/mingw-w64/mingw-w64-release/mingw-w64-v11.0.1.tar.bz2"
  sha256 "3f66bce069ee8bed7439a1a13da7cb91a5e67ea6170f21317ac7f5794625ee10"
  license "ZPL-2.1"
  revision 1

  livecheck do
    url :stable
    regex(%r{url=.*?release/mingw-w64[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_sonoma:   "23bc143dd67813633809b4c3e4dc55e3df8ac5caf0a46c907e5ee4144d8ba795"
    sha256 arm64_ventura:  "8f7d64046159f3beec798e3391c51e67920ebc99ee2b1a8252df8682d84c8fe6"
    sha256 arm64_monterey: "17600993b50aa78822a26f89d2114ed66af8a971283eac647f71fbfa733df115"
    sha256 sonoma:         "e8479418baa407eacb531d7ef5d68cc84b232e83763a0d67f60fc5d51de8d5c5"
    sha256 ventura:        "74e70a471992847885d038bd9d3676f6b46578feee50ec5c4cfbc1a536e76aca"
    sha256 monterey:       "443b5cf4c95ea974e4f856c0e0f550adf5cf7c3232728fe79fe45614a43416f1"
    sha256 x86_64_linux:   "09a7471db743ad24d96de7cd826df1c0b126e5519ff0119db92edb5ddd1c3ede"
  end

  # Apple's makeinfo is old and has bugs
  depends_on "texinfo" => :build

  depends_on "gmp"
  depends_on "isl"
  depends_on "libmpc"
  depends_on "mpfr"

  resource "binutils" do
    url "https://ftp.gnu.org/gnu/binutils/binutils-2.41.tar.xz"
    mirror "https://ftpmirror.gnu.org/binutils/binutils-2.41.tar.xz"
    sha256 "ae9a5789e23459e59606e6714723f2d3ffc31c03174191ef0d015bdf06007450"
  end

  resource "gcc" do
    url "https://ftp.gnu.org/gnu/gcc/gcc-13.2.0/gcc-13.2.0.tar.xz"
    mirror "https://ftpmirror.gnu.org/gcc/gcc-13.2.0/gcc-13.2.0.tar.xz"
    sha256 "e275e76442a6067341a27f04c5c6b83d8613144004c0413528863dc6b5c743da"

    # Backport fix for ctype build errors with Xcode 15.3
    patch do
      url "https://gcc.gnu.org/git/?p=gcc.git;a=patch;h=9970b576b7e4ae337af1268395ff221348c4b34a"
      sha256 "968bfcb58f75d889470f2f815787f6aa254fb43f1e5516e04f577dad22259905"
    end

    # Backport fix for libcc1 std::vector build errors with Xcode 15.3
    patch do
      url "https://gcc.gnu.org/git/?p=gcc.git;a=patch;h=5213047b1d50af63dfabb5e5649821a6cb157e33"
      sha256 "0d36d0d5556aefa59dbedf821f5c9dcda940a9c6f92cb3509423f524fd93351a"
    end
  end

  def target_archs
    ["i686", "x86_64"].freeze
  end

  def install
    target_archs.each do |arch|
      arch_dir = "#{prefix}/toolchain-#{arch}"
      target = "#{arch}-w64-mingw32"

      resource("binutils").stage do
        args = %W[
          --target=#{target}
          --with-sysroot=#{arch_dir}
          --prefix=#{arch_dir}
          --enable-targets=#{target}
          --disable-multilib
          --disable-nls
        ]
        mkdir "build-#{arch}" do
          system "../configure", *args
          system "make"
          system "make", "install"
        end
      end

      # Put the newly built binutils into our PATH
      ENV.prepend_path "PATH", "#{arch_dir}/bin"

      mkdir "mingw-w64-headers/build-#{arch}" do
        system "../configure", "--host=#{target}", "--prefix=#{arch_dir}/#{target}"
        system "make"
        system "make", "install"
      end

      # Create a mingw symlink, expected by GCC
      ln_s "#{arch_dir}/#{target}", "#{arch_dir}/mingw"

      # Build the GCC compiler
      resource("gcc").stage buildpath/"gcc"
      args = %W[
        --target=#{target}
        --with-sysroot=#{arch_dir}
        --prefix=#{arch_dir}
        --with-bugurl=#{tap.issues_url}
        --enable-languages=c,c++,fortran
        --with-ld=#{arch_dir}/bin/#{target}-ld
        --with-as=#{arch_dir}/bin/#{target}-as
        --with-gmp=#{Formula["gmp"].opt_prefix}
        --with-mpfr=#{Formula["mpfr"].opt_prefix}
        --with-mpc=#{Formula["libmpc"].opt_prefix}
        --with-isl=#{Formula["isl"].opt_prefix}
        --with-zstd=no
        --disable-multilib
        --disable-nls
        --enable-threads=posix
      ]

      mkdir "#{buildpath}/gcc/build-#{arch}" do
        system "../configure", *args
        system "make", "all-gcc"
        system "make", "install-gcc"
      end

      # Build the mingw-w64 runtime
      args = %W[
        CC=#{target}-gcc
        CXX=#{target}-g++
        CPP=#{target}-cpp
        --host=#{target}
        --with-sysroot=#{arch_dir}/#{target}
        --prefix=#{arch_dir}/#{target}
      ]

      case arch
      when "i686"
        args << "--enable-lib32" << "--disable-lib64"
      when "x86_64"
        args << "--disable-lib32" << "--enable-lib64"
      end

      mkdir "mingw-w64-crt/build-#{arch}" do
        system "../configure", *args
        # Resolves "Too many open files in system"
        # bfd_open failed open stub file dfxvs01181.o: Too many open files in system
        # bfd_open failed open stub file: dvxvs00563.o: Too many open files in systembfd_open
        # https://sourceware.org/bugzilla/show_bug.cgi?id=24723
        # https://sourceware.org/bugzilla/show_bug.cgi?id=23573#c18
        ENV.deparallelize do
          system "make"
          system "make", "install"
        end
      end

      # Build the winpthreads library
      # we need to build this prior to the
      # GCC runtime libraries, to have `-lpthread`
      # available, for `--enable-threads=posix`
      args = %W[
        CC=#{target}-gcc
        CXX=#{target}-g++
        CPP=#{target}-cpp
        --host=#{target}
        --with-sysroot=#{arch_dir}/#{target}
        --prefix=#{arch_dir}/#{target}
      ]
      mkdir "mingw-w64-libraries/winpthreads/build-#{arch}" do
        system "../configure", *args
        system "make"
        system "make", "install"
      end

      args = %W[
        --host=#{target}
        --with-sysroot=#{arch_dir}/#{target}
        --prefix=#{arch_dir}
        --program-prefix=#{target}-
      ]
      mkdir "mingw-w64-tools/widl/build-#{arch}" do
        system "../configure", *args
        system "make"
        system "make", "install"
      end

      # Finish building GCC (runtime libraries)
      chdir "#{buildpath}/gcc/build-#{arch}" do
        system "make"
        system "make", "install"
      end

      # Symlinks all binaries into place
      mkdir_p bin
      Dir["#{arch_dir}/bin/*"].each { |f| ln_s f, bin }
    end
  end

  test do
    (testpath/"hello.c").write <<~EOS
      #include <stdio.h>
      #include <windows.h>
      int main() { puts("Hello world!");
        MessageBox(NULL, TEXT("Hello GUI!"), TEXT("HelloMsg"), 0); return 0; }
    EOS
    (testpath/"hello.cc").write <<~EOS
      #include <iostream>
      int main() { std::cout << "Hello, world!" << std::endl; return 0; }
    EOS
    (testpath/"hello.f90").write <<~EOS
      program hello ; print *, "Hello, world!" ; end program hello
    EOS
    # https://docs.microsoft.com/en-us/windows/win32/rpc/using-midl
    (testpath/"example.idl").write <<~EOS
      [
        uuid(ba209999-0c6c-11d2-97cf-00c04f8eea45),
        version(1.0)
      ]
      interface MyInterface
      {
        const unsigned short INT_ARRAY_LEN = 100;

        void MyRemoteProc(
            [in] int param1,
            [out] int outArray[INT_ARRAY_LEN]
        );
      }
    EOS

    ENV["LC_ALL"] = "C"
    ENV.remove_macosxsdk if OS.mac?
    target_archs.each do |arch|
      target = "#{arch}-w64-mingw32"
      outarch = (arch == "i686") ? "i386" : "x86-64"

      system "#{bin}/#{target}-gcc", "-o", "test.exe", "hello.c"
      assert_match "file format pei-#{outarch}", shell_output("#{bin}/#{target}-objdump -a test.exe")

      system "#{bin}/#{target}-g++", "-o", "test.exe", "hello.cc"
      assert_match "file format pei-#{outarch}", shell_output("#{bin}/#{target}-objdump -a test.exe")

      system "#{bin}/#{target}-gfortran", "-o", "test.exe", "hello.f90"
      assert_match "file format pei-#{outarch}", shell_output("#{bin}/#{target}-objdump -a test.exe")

      system "#{bin}/#{target}-widl", "example.idl"
      assert_predicate testpath/"example_s.c", :exist?, "example_s.c should have been created"
    end
  end
end