class Libsolv < Formula
  desc "Library for solving packages and reading repositories"
  homepage "https:github.comopenSUSElibsolv"
  url "https:github.comopenSUSElibsolvarchiverefstags0.7.33.tar.gz"
  sha256 "776f3c9cc253cd860e72c8c489c7a067c46a96d6993ff302f68d9efd03b37cba"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "8c20e921848ef410a5c77803ead0374d70ccc593aaaf543626a29263a2348a0f"
    sha256 cellar: :any,                 arm64_sonoma:  "da834535bcc64c3e6d586ec4d1371b781170b983ffa9f6874145cfc6a010d531"
    sha256 cellar: :any,                 arm64_ventura: "404a8fe6d417920bfc54e89467e81023bfff1fc719f8574db4d405b96ee1f501"
    sha256 cellar: :any,                 sonoma:        "73ef8f8def05699f78254adc9ba95a10e6f920e4d79dfee60a565e910d5da505"
    sha256 cellar: :any,                 ventura:       "060ebf653cdd06678c533fe7f23c621e4ad5031ae93ae964446de8b685cce3e6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4978a9432bab01ba6bdb3d312204bb69ca97b1bc85d87834328a8cd4947ccf09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eb1d5d0e1b803b524614e71271e5634ccb4fde5f52e6fd62361bce44a9687e15"
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
    (testpath"test.cpp").write <<~CPP
      #include <solvpool.h>
      #include <solvrepo.h>

      int main(int argc, char **argv) {
        Pool *pool = pool_create();

        Repo *repo = repo_create(pool, "test");

        pool_free(pool);
      }
    CPP
    system ENV.cc, "test.cpp", "-I#{include}", "-L#{lib}", "-lsolv", "-o", "test"
    system ".test"
  end
end