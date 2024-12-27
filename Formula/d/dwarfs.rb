class Dwarfs < Formula
  desc "Fast high compression read-only file system for Linux, Windows, and macOS"
  homepage "https:github.commhxdwarfs"
  url "https:github.commhxdwarfsreleasesdownloadv0.10.2dwarfs-0.10.2.tar.xz"
  sha256 "36767290a39f92782e41daaa3eb45e39550ad1a4294a6d8365bc0f456f75f00c"
  license "GPL-3.0-or-later"
  revision 2

  livecheck do
    url :stable
    regex(^(?:release[._-])?v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0127ed41fef6cd7891a69796991bc2787981396af298a7a36d1d03b7215981ba"
    sha256 cellar: :any,                 arm64_sonoma:  "f89ab31df9f6fc3cc001f967a2ec2dfa4ea3dbfb085bca655f100e3609870ae1"
    sha256 cellar: :any,                 arm64_ventura: "075281d2e741c898f5f1f9f3dda9a61afdc503f85ab8f7cd59494b1b14f2942e"
    sha256 cellar: :any,                 sonoma:        "18855485cc060d03cab334ee1ca7de0d2741991ea30ecb79ddf1d5fda511a25f"
    sha256 cellar: :any,                 ventura:       "46caaa93ea6a98c8fd61626634690d4a8637dbd3ae531e7b5a7b2bd879c75df2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b2b54763c76ab0f6052c01cc4b94fc3894ea45b1a0ae031537b369607db20e55"
  end

  depends_on "cmake" => :build
  depends_on "googletest" => :build
  depends_on "pkgconf" => :build
  depends_on "boost"
  depends_on "brotli"
  depends_on "double-conversion"
  depends_on "flac"
  depends_on "fmt"
  depends_on "gflags"
  depends_on "glog"
  depends_on "howard-hinnant-date"
  depends_on "libarchive"
  depends_on "libevent"
  depends_on "libsodium"
  depends_on "lz4"
  depends_on "nlohmann-json"
  depends_on "openssl@3"
  depends_on "parallel-hashmap"
  depends_on "range-v3"
  depends_on "utf8cpp"
  depends_on "xxhash"
  depends_on "xz"
  depends_on "zstd"

  on_macos do
    depends_on "llvm" if DevelopmentTools.clang_build_version < 1500
  end

  on_linux do
    depends_on "jemalloc"
  end

  fails_with :clang do
    build 1499
    cause "Not all required C++20 features are supported"
  end

  def install
    args = %W[
      -DBUILD_SHARED_LIBS=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DWITH_LIBDWARFS=ON
      -DWITH_TOOLS=ON
      -DWITH_FUSE_DRIVER=OFF
      -DWITH_TESTS=ON
      -DWITH_MAN_PAGES=ON
      -DENABLE_PERFMON=ON
      -DTRY_ENABLE_FLAC=ON
      -DENABLE_RICEPP=ON
      -DENABLE_STACKTRACE=OFF
      -DDISABLE_CCACHE=ON
      -DDISABLE_MOLD=ON
      -DPREFER_SYSTEM_GTEST=ON
    ]

    if OS.mac? && DevelopmentTools.clang_build_version < 1500
      ENV.llvm_clang

      # Needed in order to find the C++ standard library
      # See: https:github.comHomebrewhomebrew-coreissues178435
      ENV.prepend "LDFLAGS", "-L#{Formula["llvm"].opt_lib}c++ -L#{Formula["llvm"].opt_lib} -lunwind"
    end

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    # produce a dwarfs image
    system bin"mkdwarfs", "-i", prefix, "-o", "test.dwarfs", "-l4"

    # check the image
    system bin"dwarfsck", "test.dwarfs"

    # get JSON info about the image
    info = JSON.parse(shell_output("#{bin}dwarfsck test.dwarfs -j"))
    assert_equal info["created_by"], "libdwarfs v#{version}"
    assert info["inode_count"] >= 10

    # extract the image
    system bin"dwarfsextract", "-i", "test.dwarfs"
    assert_path_exists "binmkdwarfs"
    assert_path_exists "sharemanman1mkdwarfs.1"
    assert compare_file bin"mkdwarfs", "binmkdwarfs"

    (testpath"test.cpp").write <<~CPP
      #include <iostream>
      #include <dwarfsversion.h>

      int main(int argc, char **argv) {
        int v = dwarfs::get_dwarfs_library_version();
        int major = v  10000;
        int minor = (v % 10000)  100;
        int patch = v % 100;
        std::cout << major << "." << minor << "." << patch << std::endl;
        return 0;
      }
    CPP

    # ENV.llvm_clang doesn't work in the test block
    ENV["CXX"] = Formula["llvm"].opt_bin"clang++" if OS.mac? && DevelopmentTools.clang_build_version < 1500

    system ENV.cxx, "-std=c++20", "test.cpp", "-I#{include}", "-L#{lib}", "-o", "test", "-ldwarfs_common"

    assert_equal version.to_s, shell_output(".test").chomp
  end
end