class Tiledb < Formula
  desc "Universal storage engine"
  homepage "https://tiledb.com/"
  url "https://ghfast.top/https://github.com/TileDB-Inc/TileDB/archive/refs/tags/2.29.1.tar.gz"
  sha256 "e507b6edf2a3893038ae92c74b4756561f3c11a03c6c311c7ae76d40f924cc05"
  license "MIT"
  revision 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2ea8ec428713a5d5a96d2df5b0dd1a1c4d64e1460f941f02d2530563282f5edf"
    sha256 cellar: :any,                 arm64_sequoia: "b4a7cb0afc697e8eee4a284ba10514e9cb2517dd597ae43e422f0762585e2a29"
    sha256 cellar: :any,                 arm64_sonoma:  "cee07b8aacd7dde847733a14eaca823162e7dd1ad96a3d07f359aaa98aa867ab"
    sha256 cellar: :any,                 sonoma:        "fc16fac08844fb22c97461fabba00f961ec801da760db8f326a4c7e8bdc28094"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8745677ca08f476afaa45eb69d5f247b72a5b45304d501bed7f45099e9994e8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "778a852f2820593ef0f5d2f07e64df239222bc5ed1b88220017b8374615b1b92"
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