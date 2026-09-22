class Libsolv < Formula
  desc "Library for solving packages and reading repositories"
  homepage "https://github.com/openSUSE/libsolv"
  url "https://ghfast.top/https://github.com/openSUSE/libsolv/archive/refs/tags/0.7.40.tar.gz"
  sha256 "30f529ad39d23bdc284b81ea3ed29679162011fc5fb9392635db0b4d1c8e3511"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "e91e7d84e5bd0b42544fbd0070c9066644a3a8e1b3a168bdd8ad20bfe21f3fc0"
    sha256 cellar: :any, arm64_tahoe:       "1c138aa288008e33c7d9dd1c006dc3248da8d684f92ea11a2ec489168f994889"
    sha256 cellar: :any, arm64_sequoia:     "1247aaf9aa468e31fa43f173d64ce07b3fbf9e8a0a98f2b6369171d290af8b94"
    sha256 cellar: :any, arm64_linux:       "960c9f4ee0d7f64ac5f567e229b68819f8e5275fa252cef162a4b163767ac074"
    sha256 cellar: :any, x86_64_linux:      "fd2baa871032917426101d6d1f369c066934929b06e709aad69c73968b60371f"
  end

  depends_on "cmake" => :build
  depends_on "rpm"
  depends_on "xz"
  depends_on "zstd"

  uses_from_macos "bzip2"
  uses_from_macos "expat"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

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
      -DENABLE_RPMDB=ON
      -DENABLE_RPMMD=ON
      -DENABLE_RPMPKG=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <solv/pool.h>
      #include <solv/repo.h>

      int main(int argc, char **argv) {
        Pool *pool = pool_create();

        Repo *repo = repo_create(pool, "test");

        pool_free(pool);
      }
    CPP
    system ENV.cc, "test.cpp", "-I#{include}", "-L#{lib}", "-lsolv", "-o", "test"
    system "./test"
  end
end