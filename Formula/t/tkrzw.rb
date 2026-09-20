class Tkrzw < Formula
  desc "Set of implementations of DBM"
  homepage "https://dbmx.net/tkrzw/"
  url "https://dbmx.net/tkrzw/pkg/tkrzw-1.0.33.tar.gz"
  sha256 "faa41fdad6a27ae11fbf29d185c142761ea8bad4ae89382d16ccc3f2fae0e39c"
  license "Apache-2.0"

  livecheck do
    url "https://dbmx.net/tkrzw/pkg/"
    regex(/href=.*?tkrzw[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_golden_gate: "5865ac984d39f4fb153ae44920466fdea6d4ba8a86af561c60a515ae5ac6d825"
    sha256 arm64_tahoe:       "cb4b48332204e75f562e3c50921dad32ca438d271bcbe5c290457acab6d70613"
    sha256 arm64_sequoia:     "b7aa8e0461e051c758fcdf515864f06febc33cdf5ff9d6612650e5f8cd99ccfb"
    sha256 arm64_linux:       "ccf6eb112f27fee8a4c894470d1e5c5c28d29f7363487d01426b9812a6abdec9"
    sha256 x86_64_linux:      "3935085ecc08d9a4db49ddb135d5f28687b9a00ce5be722cdb80c89983f5875a"
  end

  depends_on "lz4"
  depends_on "xz"
  depends_on "zstd"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def install
    # Don't add -lstdc++ to tkrzw_build_util and tkrzw.pc
    ENV["ac_cv_lib_stdcpp_main"] = "no" if ENV.compiler == :clang

    # zstd support is needed by dependents. Other features are for indirect dependencies.
    # Also force shim path for CC/CXX as configure seems to use a different PATH
    args = %W[
      --enable-lz4
      --enable-lzma
      --enable-zlib
      --enable-zstd
      CC=#{which(ENV.cc)}
      CXX=#{which(ENV.cxx)}
    ]

    system "./configure", *args, *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include "tkrzw_dbm_hash.h"
      int main(int argc, char** argv) {
        tkrzw::HashDBM dbm;
        dbm.Open("casket.tkh", true).OrDie();
        dbm.Set("hello", "world").OrDie();
        std::cout << dbm.GetSimple("hello") << std::endl;
        dbm.Close().OrDie();
        return 0;
      }
    CPP

    cflags = shell_output("#{bin}/tkrzw_build_util config -i").chomp.split
    ldflags = shell_output("#{bin}/tkrzw_build_util config -l").chomp.split
    ldflags.unshift "-L#{HOMEBREW_PREFIX}/lib"
    system ENV.cxx, "-std=c++17", "test.cpp", "-o", "test", *cflags, *ldflags
    assert_equal "world\n", shell_output("./test")
  end
end