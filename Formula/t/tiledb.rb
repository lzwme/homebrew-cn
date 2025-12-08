class Tiledb < Formula
  desc "Universal storage engine"
  homepage "https://tiledb.com/"
  url "https://ghfast.top/https://github.com/TileDB-Inc/TileDB/archive/refs/tags/2.30.0.tar.gz"
  sha256 "c5f94da6de0e0f93925f7ad107bd80fef0615f9b3d111a5bae245f75b1fcc173"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d24643620924306af3314b92336a425196ee12ac582b5cf454aeb95918c82e34"
    sha256 cellar: :any,                 arm64_sequoia: "447fb3b5eb102ae3ed47d77b6aa1f978c9b3d3e1b7a23090d3ef2886b685320f"
    sha256 cellar: :any,                 arm64_sonoma:  "92da40d1dd7e7dfe082f95eeadceb9a8190d6db64d454a14820d1d4b68e7771e"
    sha256 cellar: :any,                 sonoma:        "f38a90aa06777eaa085e4f92fb496dadb443db1de3c7ebf1f2d43b15def77776"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2b521539ed19cbb3f04687298c61c2ebe9fd0cb6fb2cb845dc2915f543ecbbba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8e78c42be0f23e86e08deb5490473fbaee901d311aa8950fdd07b620ccb96066"
  end

  depends_on "c-blosc2" => :build
  depends_on "cmake" => :build
  depends_on "nlohmann-json" => :build

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