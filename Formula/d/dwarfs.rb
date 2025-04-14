class Dwarfs < Formula
  desc "Fast high compression read-only file system for Linux, Windows, and macOS"
  homepage "https:github.commhxdwarfs"
  url "https:github.commhxdwarfsreleasesdownloadv0.12.1dwarfs-0.12.1.tar.xz"
  sha256 "5523a5c3aea244cbfbccfe64f1df6053b3901e6af8916fac1530faf0f7a5f07f"
  license "GPL-3.0-or-later"
  revision 1

  livecheck do
    url :stable
    regex(^(?:release[._-])?v?(\d+(?:\.\d+)+)$i)
    strategy :github_latest
  end

  bottle do
    sha256                               arm64_sequoia: "b95bbd2019e3114fb67f0536c192005603ee47eb056101e17a5d94f84399ea76"
    sha256                               arm64_sonoma:  "48a77a064523c35426db53d84e87c4ad80f21dabd7f55ef925ff90c557fc7622"
    sha256                               arm64_ventura: "d6fca37e54838bea9befb6fa42df95f21fc09925a01dbf0d5f7a6d05f5bed5fc"
    sha256 cellar: :any,                 sonoma:        "7c11a116190dea7c1d8e8ac159257ece5fc373dcf28bf8e494481b20e6717533"
    sha256 cellar: :any,                 ventura:       "626dc822ccc083fc48fa0b9f66739acce2b2e9e83e32fac6015cf6a7c4f9e0db"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "488af58ed8604bbdecc1f426a87a8f51230db2b6086c12cf25057936a946db5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5a71d23a3844150fcf83ebc46920e8531b2df946f86a36ead4704778806a2009"
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
    depends_on "llvm" if DevelopmentTools.clang_build_version <= 1500
  end

  on_linux do
    depends_on "jemalloc"
  end

  fails_with :clang do
    build 1500
    cause "Not all required C++20 features are supported"
  end

  # Backport folly fix for LLVM 20
  patch do
    url "https:github.comfacebookfollycommitef5160f6b02fb8eb971adf7edd3aea96ef73bc66.patch?full_index=1"
    sha256 "66db8650dc30d285064fcccb93c5d4e7384cefae091b1fc76eddede279271332"
    directory "folly"
  end

  # Apply folly fix for LLVM 20 from https:github.comfacebookfollypull2404
  patch do
    url "https:github.comfacebookfollycommit1215a574e29ea94653dd8c48f72e25b5503ced18.patch?full_index=1"
    sha256 "14a584c4f0a166d065d45eb691c23306289a5287960806261b605946166de590"
    directory "folly"
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

    if OS.mac? && DevelopmentTools.clang_build_version <= 1500
      ENV.llvm_clang

      # Needed in order to find the C++ standard library
      # See: https:github.comHomebrewhomebrew-coreissues178435
      ENV.prepend "LDFLAGS", "-L#{Formula["llvm"].opt_lib}unwind -lunwind"
      ENV.prepend_path "HOMEBREW_LIBRARY_PATHS", Formula["llvm"].opt_lib"c++"
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
    ENV["CXX"] = Formula["llvm"].opt_bin"clang++" if OS.mac? && DevelopmentTools.clang_build_version <= 1500

    system ENV.cxx, "-std=c++20", "test.cpp", "-I#{include}", "-L#{lib}", "-o", "test", "-ldwarfs_common"

    assert_equal version.to_s, shell_output(".test").chomp
  end
end