class Libsolv < Formula
  desc "Library for solving packages and reading repositories"
  homepage "https://github.com/openSUSE/libsolv"
  url "https://ghfast.top/https://github.com/openSUSE/libsolv/archive/refs/tags/0.7.38.tar.gz"
  sha256 "08487f070e6178e024a3f36f9d8759e0466dc1d13e30bfe31cab5bbef2fa7be1"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e83e0a9de6d9cbf3c2d9322bb620d61b8f64033f3283658d2a6ed7f6b9c3c5c4"
    sha256 cellar: :any,                 arm64_sequoia: "5f9d0996ea4e98f02706544952386796dde376eb536ecd5ca9681938dbe7a987"
    sha256 cellar: :any,                 arm64_sonoma:  "f5f18bab60e06db98ecc9a21a65edd74454fb9ed1d6ddd442e0e18d6b7753b39"
    sha256 cellar: :any,                 sonoma:        "720522ea6e3419bbb936095f95a529653a847086d31b99940f08fad45b421ca6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fdeccd1b0a6957057bce004ef1fd28eae48d073bdfb3e463c8e7dc8cc5e5a9ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c0b66426fbedb40b42f7c8bd93db2ccbb313a7ad147f3659f2ab917fc0344d52"
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