class Libsolv < Formula
  desc "Library for solving packages and reading repositories"
  homepage "https:github.comopenSUSElibsolv"
  url "https:github.comopenSUSElibsolvarchiverefstags0.7.27.tar.gz"
  sha256 "5c492ab1847dfd0ac485c0bb35609e7ff18fe9645a26498e2d5373ab728cfd3f"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "08e100a725b112e49604e1a0ccf4c0cc6f9197ec3d3252b123180f7efbffac90"
    sha256 cellar: :any,                 arm64_ventura:  "fab59dc04b6ec3f3577731e1f664931c6c2258687c6a30b40328affcddcb3faf"
    sha256 cellar: :any,                 arm64_monterey: "f23258f2a0ee2902caa596a227e7fd28a5cb02ec689fb3c5878114240d0e1fcb"
    sha256 cellar: :any,                 sonoma:         "ad458309393f2055efb68898d27a492f1684b08bfd310c3a9a8d315c53182995"
    sha256 cellar: :any,                 ventura:        "9098cc70f42adeee0ebb4e2bf57ce6b64fee57a26c170ead04d4b854d59e2ca8"
    sha256 cellar: :any,                 monterey:       "6778e51555ff1c56d51f2c27bb43bc400d81a7ef05b298f3ecd80e467643e238"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a75a64bd1fd7f6b9ae0e8c71304918e720847af0a394fed73ea9d5b02f4c4aa9"
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
    (testpath"test.cpp").write <<~EOS
      #include <solvpool.h>
      #include <solvrepo.h>

      int main(int argc, char **argv) {
        Pool *pool = pool_create();

        Repo *repo = repo_create(pool, "test");

        pool_free(pool);
      }
    EOS
    system ENV.cc, "test.cpp", "-I#{include}", "-L#{lib}", "-lsolv", "-o", "test"
    system ".test"
  end
end