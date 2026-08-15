class Dwarfs < Formula
  desc "Fast high compression read-only file system for Linux, Windows, and macOS"
  homepage "https://github.com/mhx/dwarfs"
  url "https://ghfast.top/https://github.com/mhx/dwarfs/releases/download/v0.15.6/dwarfs-0.15.6.tar.xz"
  sha256 "087b77c1d6a1f253df896b054f95ef17469c63b00be51f4d081633cc8817481c"
  license "GPL-3.0-or-later"
  revision 1

  livecheck do
    url :stable
    regex(/^(?:release[._-])?v?(\d+(?:\.\d+)+)$/i)
    strategy :github_latest
  end

  bottle do
    sha256               arm64_tahoe:   "63b397314401edc3e15b73766d29f80d7bd73f22ea51aa26a58b3e7f00d3c698"
    sha256               arm64_sequoia: "8215d5880d11a768eb178a3e552ce48ab43ed82d2b7162738981011552603535"
    sha256               arm64_sonoma:  "67398d29589fe65d5879475a54989634c09f41be359e08112f4d257553e448fb"
    sha256 cellar: :any, sonoma:        "4e04048bddf039470771fb7eb4beae08c954ca576f95219366c1d60138d09e72"
    sha256 cellar: :any, arm64_linux:   "171056f34b9d39ca019d61ff6dee017b307280c412d6ba3a74e2a0406a26b15b"
    sha256 cellar: :any, x86_64_linux:  "f90ad90e2265b937bc576a6bf4517ce268d8e83a970daa4e85b741334b4b1b01"
  end

  depends_on "cmake" => :build
  depends_on "googletest" => :build
  depends_on "pkgconf" => :build
  depends_on "boost"
  depends_on "brotli"
  depends_on "flac"
  depends_on "fmt"
  depends_on "howard-hinnant-date"
  depends_on "libarchive"
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
    cause "Not all required C++23 features are supported"
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

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    # produce a dwarfs image
    system bin/"mkdwarfs", "-i", prefix, "-o", "test.dwarfs", "-l4"

    # check the image
    system bin/"dwarfsck", "test.dwarfs"

    # get JSON info about the image
    info = JSON.parse(shell_output("#{bin}/dwarfsck test.dwarfs -j"))
    assert_equal info["created_by"], "libdwarfs v#{version}"
    assert_operator 10, :<=, info["inode_count"]

    # extract the image
    system bin/"dwarfsextract", "-i", "test.dwarfs"
    assert_path_exists "bin/mkdwarfs"
    assert_path_exists "share/man/man1/mkdwarfs.1"
    assert compare_file bin/"mkdwarfs", "bin/mkdwarfs"

    (testpath/"test.cpp").write <<~CPP
      #include <iostream>
      #include <dwarfs/version.h>

      int main(int argc, char **argv) {
        int v = dwarfs::get_dwarfs_library_version();
        int major = v / 10000;
        int minor = (v % 10000) / 100;
        int patch = v % 100;
        std::cout << major << "." << minor << "." << patch << std::endl;
        return 0;
      }
    CPP

    system ENV.cxx, "-std=c++23", "test.cpp", "-I#{include}", "-L#{lib}", "-Wl,-rpath,#{lib}",
                    "-o", "test", "-ldwarfs_common"

    assert_equal version.to_s, shell_output("./test").chomp
  end
end