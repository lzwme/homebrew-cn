class Dwarfs < Formula
  desc "Fast high compression read-only file system for Linux, Windows, and macOS"
  homepage "https:github.commhxdwarfs"
  url "https:github.commhxdwarfsreleasesdownloadv0.11.3dwarfs-0.11.3.tar.xz"
  sha256 "5ccfc293d74e0509a848d10416b9682cf7318c8fa9291ba9e92e967b9a6bb994"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(^(?:release[._-])?v?(\d+(?:\.\d+)+)$i)
    strategy :github_latest
  end

  bottle do
    sha256                               arm64_sequoia: "ee48a79a72ef1a1dc96d86b467a7b4c1a9fd8ddccf71c684d0932df726acddcc"
    sha256                               arm64_sonoma:  "c94948fc5aee93e64a1c53d29df4589af17fd2454a49134502e55feaf83b81a9"
    sha256                               arm64_ventura: "9bf358118fd31a0901d4141b3bb1e58334672d9f6809529db375b3a21f3a0716"
    sha256 cellar: :any,                 sonoma:        "0788e7539e03265d6b2451299afc5cb2f8e1c86071bf9375fcc98caec84b6670"
    sha256 cellar: :any,                 ventura:       "ab214e70ea62ad01c9c7ecbbfc3833cd14bcb89f7b7fea1715fda6fac3b27183"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "89ad78dd543574f1d69a9c7cff4961e9c16d1fd0dfb6b020e7ef519276ce107a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2d1adc2ca92720340ba458aa4d8003e90b011f01ef16f01236e8a1fda02c833e"
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
    # Workaround for CMake 4 until https:github.comfacebookfollypull2398
    # This only goes into effect if it is higher than `cmake_minimum_required`
    # so it only impacts submodules and not the main DwarFS which uses 3.28.0
    ENV["CMAKE_POLICY_VERSION_MINIMUM"] = "3.5"

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
      ENV.prepend "LDFLAGS", "-L#{Formula["llvm"].opt_lib}c++ -L#{Formula["llvm"].opt_lib}unwind -lunwind"
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