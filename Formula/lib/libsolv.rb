class Libsolv < Formula
  desc "Library for solving packages and reading repositories"
  homepage "https://github.com/openSUSE/libsolv"
  url "https://ghfast.top/https://github.com/openSUSE/libsolv/archive/refs/tags/0.7.35.tar.gz"
  sha256 "e6ef552846f908beb3bbf6ca718b6dd431bd8a281086d82af9a6d2a3ba919be5"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_tahoe:   "72baee113a3ee720b1ece1944fa2ed5eed559e86255287929dd2b53ffff028e2"
    sha256 cellar: :any,                 arm64_sequoia: "a425f21b81b1df18f797a4c21a88c1a5783673ffe9de0310dffcf2129cbc7d09"
    sha256 cellar: :any,                 arm64_sonoma:  "0b3016f7c6dd93632c2d53355bd4fc775af5b40b13e59ba9f93ce4d5905cf408"
    sha256 cellar: :any,                 sonoma:        "2d99b3f6594519bcace1fbba7f3f3bc5ba22a38e544861be43cf5e893bbdbce2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8628bcc2dece4bccbb2ebb973bd957655a08e4c309240f981818d35380cb0a2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c3c71e6ba50b6473113475af7a26884aa1b8314d6c6f5ddff2c1bed3e2fe5bb6"
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