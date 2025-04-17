class Dwarfs < Formula
  desc "Fast high compression read-only file system for Linux, Windows, and macOS"
  homepage "https:github.commhxdwarfs"
  url "https:github.commhxdwarfsreleasesdownloadv0.12.2dwarfs-0.12.2.tar.xz"
  sha256 "9b256d1f2bc17917cd63a1bee3bd5f505076b4d880fcf9daa18a6ca5bca35aeb"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(^(?:release[._-])?v?(\d+(?:\.\d+)+)$i)
    strategy :github_latest
  end

  bottle do
    sha256                               arm64_sequoia: "dafeb88fee34b87cfbf5983fd135c663486f824cd482fcec136ea225b512d2d2"
    sha256                               arm64_sonoma:  "4919cd0620778dc4f6bd1231964623934736f542a8b8cc821f802ae3b017e06d"
    sha256                               arm64_ventura: "bdae56e82bb1f78fc9ba419de3f6753e207061e4d1e13d860a932b275276f354"
    sha256 cellar: :any,                 sonoma:        "e9e2b8a85484cc6e503b9b49d5e050fbab725d259ea586fe982c16cfac49503f"
    sha256 cellar: :any,                 ventura:       "65de4763b4dcfaa51f9143ed60d3f176ca5e025bc1c4b3ecf2ccd9d5a16915e5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dae58b9785b7dad6b91bf16c44bfca573bac302b5ca8788ca80ee0e4d540aae9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b928af57c4d4dc4b0e21e451bf5e81358261c770f2b413c28364fd033d5f90d5"
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