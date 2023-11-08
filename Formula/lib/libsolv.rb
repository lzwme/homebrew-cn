class Libsolv < Formula
  desc "Library for solving packages and reading repositories"
  homepage "https://github.com/openSUSE/libsolv"
  url "https://ghproxy.com/https://github.com/openSUSE/libsolv/archive/refs/tags/0.7.26.tar.gz"
  sha256 "acc796d42f2eb3c2e553c3d22a6e64ef196b3bf77db2959b1bfd9dfc1e29bfbc"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "21028b36867b8e493c7915150e75394557a6428cbcdcab6f94c6277e97c9b3b7"
    sha256 cellar: :any,                 arm64_ventura:  "7178381e4144e9ff4f61ecb44d93e84f8754e7185477e703bb9f1d050a6ada6c"
    sha256 cellar: :any,                 arm64_monterey: "6d9dc6ee1664af1fdaea3c85ca44fef42959a13dde7dab5cc05c9cccefbea37a"
    sha256 cellar: :any,                 sonoma:         "c2879f5a4e7cd97c3da8c2ec1329a782aec730bb56c85884dd754ebcbfa951b7"
    sha256 cellar: :any,                 ventura:        "3f11282c935168d260d9ffcc680a8698e04a2c4fc5f935a7c4ae66c1d41978f6"
    sha256 cellar: :any,                 monterey:       "ff37983dc63dcfd82a99310367c6699cf14d55008ed3276d0c2dfa871098bb6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "62360f9d2902437044e639305ca2261ae9c976d71e789ac3ea8527a57c19f9c0"
  end

  depends_on "cmake" => :build
  depends_on "xz"
  depends_on "zstd"

  uses_from_macos "bzip2"
  uses_from_macos "expat"
  uses_from_macos "zlib"

  def install
    args = %W[
      -DENABLE_STATIC=ON
      -DENABLE_SUSEREPO=ON
      -DENABLE_COMPS=ON
      -DENABLE_HELIXREPO=ON
      -DENABLE_DEBIAN=ON
      -DENABLE_MDKREPO=ON
      -DENABLE_ARCHREPO=ON
      -DENABLE_CUDFREPO=ON
      -DENABLE_CONDA=ON
      -DENABLE_APPDATA=ON
      -DMULTI_SEMANTICS=ON
      -DENABLE_LZMA_COMPRESSION=ON
      -DENABLE_BZIP2_COMPRESSION=ON
      -DENABLE_ZSTD_COMPRESSION=ON
      -DENABLE_ZCHUNK_COMPRESSION=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <solv/pool.h>
      #include <solv/repo.h>

      int main(int argc, char **argv) {
        Pool *pool = pool_create();

        Repo *repo = repo_create(pool, "test");

        pool_free(pool);
      }
    EOS
    system ENV.cc, "test.cpp", "-I#{include}", "-L#{lib}", "-lsolv", "-o", "test"
    system "./test"
  end
end