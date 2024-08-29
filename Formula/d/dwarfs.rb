class Dwarfs < Formula
  desc "Fast high compression read-only file system for Linux, Windows, and macOS"
  homepage "https:github.commhxdwarfs"
  url "https:github.commhxdwarfsreleasesdownloadv0.10.1dwarfs-0.10.1.tar.xz"
  sha256 "db785e0e0f257fa4363d90153db34127add4552791a72998b30ded787840d039"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "bf3bcf5ba84f8259d31b59e380ce6c5d181a482ae3a2e892ef7cda2af8a7357a"
    sha256 cellar: :any,                 arm64_ventura:  "f25b395ed92f5b72bd8d5401377c1996e90b46d9cc47b0b18205d2c309c6ce6f"
    sha256 cellar: :any,                 arm64_monterey: "a4035625ea8bb45b2720efb6df28286f67a48be32977603df1f2a1778cb35715"
    sha256 cellar: :any,                 sonoma:         "32d494747112a9858b1d93d3dc74e08087272b1c28e2a6cf90431150ff058866"
    sha256 cellar: :any,                 ventura:        "aeeb7fb1d99658e5c1311d79607720b0d5fbf13337e8155ddcf51a319b926093"
    sha256 cellar: :any,                 monterey:       "7cead4241d72e2f328a1284efce7489e09fa42630fe9242a9dde41026838bf4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9cafeff56db381b4ec58754b7d33326f174757845338e138a1c14f4673be3247"
  end

  depends_on "cmake" => :build
  depends_on "googletest" => :build
  depends_on "pkg-config" => :build
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

  fails_with :gcc do
    version "11"
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
    system "cmake", "--build", "build", "--parallel"
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

    (testpath"test.cpp").write <<~EOS
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
    EOS

    # ENV.llvm_clang doesn't work in the test block
    ENV["CXX"] = Formula["llvm"].opt_bin"clang++" if OS.mac? && DevelopmentTools.clang_build_version < 1500

    system ENV.cxx, "-std=c++20", "test.cpp", "-I#{include}", "-L#{lib}", "-o", "test", "-ldwarfs_common"

    assert_equal version.to_s, shell_output(".test").chomp
  end
end