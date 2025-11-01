class Tiledb < Formula
  desc "Universal storage engine"
  homepage "https://tiledb.com/"
  url "https://ghfast.top/https://github.com/TileDB-Inc/TileDB/archive/refs/tags/2.29.1.tar.gz"
  sha256 "e507b6edf2a3893038ae92c74b4756561f3c11a03c6c311c7ae76d40f924cc05"
  license "MIT"
  revision 2

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "fddeb76bf28760be96460e3bbac36bc271822d4e9c58f2eff64a5bee9f890494"
    sha256 cellar: :any,                 arm64_sequoia: "bce96a06ef04735d43f6a778c85fe292234d07f2d52b82da0c59e2c452d8394f"
    sha256 cellar: :any,                 arm64_sonoma:  "c4b287665441eb33547d34fff306761eb3a5ef46037673ae4b331c77c874bb0c"
    sha256 cellar: :any,                 sonoma:        "2df9af09b803bed610a054c5c0c8e6ed8f62cbf7c91a54e35256f36ee9a380d1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "043165f31f6e3b169b2104d8c2b75f8b13aca8d31096cf1626f98743aa8866e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "be3685b9d9c7cfa97ab6b50512d739f2614cabdcd2e962c0db39a8c36c4ca410"
  end

  depends_on "cmake" => :build

  depends_on "fmt"
  depends_on "lz4"
  depends_on "openssl@3"
  depends_on "spdlog"
  depends_on "webp"
  depends_on "zstd"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  def install
    args = %w[
      -DTILEDB_EXPERIMENTAL_FEATURES=OFF
      -DTILEDB_TESTS=OFF
      -DTILEDB_VERBOSE=ON
      -DTILEDB_WERROR=OFF
      -DTILEDB_DISABLE_AUTO_VCPKG=ON
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <tiledb/tiledb>
      #include <iostream>

      int main() {
        auto [major, minor, patch] = tiledb::version();
        std::cout << major << "." << minor << "." << patch << std::endl;
        return 0;
      }
    CPP
    system ENV.cxx, "test.cpp", "-std=c++17", "-I#{include}", "-L#{lib}", "-ltiledb", "-o", "test"
    assert_match version.to_s, shell_output("./test")
  end
end