class Dwarfs < Formula
  desc "Fast high compression read-only file system for Linux, Windows, and macOS"
  homepage "https:github.commhxdwarfs"
  url "https:github.commhxdwarfsreleasesdownloadv0.10.1dwarfs-0.10.1.tar.xz"
  sha256 "db785e0e0f257fa4363d90153db34127add4552791a72998b30ded787840d039"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "ac66bc8a18bdfc897548731723b3549aac3fc8222b359b1f9ba4c115f8d0b051"
    sha256 cellar: :any,                 arm64_ventura:  "e69e7e11bb94bf5481437b4f8f9d9694e7f2588d93a56e712ffca0f7e14e2ec9"
    sha256 cellar: :any,                 arm64_monterey: "8f08a754b8d9ca3635365df9d2e1bad7214dcd69e5ad1b037248eed9cf4087cd"
    sha256 cellar: :any,                 sonoma:         "3aedf5e7628c2e4fa2627d7c55fa1e75a673e53c0b58f4982b37985475826f8c"
    sha256 cellar: :any,                 ventura:        "6779a4d28b9c8216e2eb5941132ae047aa692e033ae80172dc25304202a74e00"
    sha256 cellar: :any,                 monterey:       "0f0be64c35b93413eab13651ed20aa31963de6a7811fdb3a97e4e8a33856b252"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dc0f67e5abb674e076a346043f944445ffe62924c36f60cef5d8d1aa0147bf6c"
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