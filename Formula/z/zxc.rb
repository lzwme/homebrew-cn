class Zxc < Formula
  desc "High-performance asymmetric lossless compression library"
  homepage "https://github.com/hellobertrand/zxc"
  url "https://ghfast.top/https://github.com/hellobertrand/zxc/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "14a4016ff92e0981efb5c74ecc80e0ecea178287ea899c2d38d406323104797f"
  license "BSD-3-Clause"
  head "https://github.com/hellobertrand/zxc.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "723ce9338871e6e81336f8357dce191f0a4d04751e46455f10770f5090ec1ccf"
    sha256 cellar: :any,                 arm64_sequoia: "871914782b83ec89f236147be5dfb38ba64059ee8f117efb70899a0be9e0e993"
    sha256 cellar: :any,                 arm64_sonoma:  "52caa2e12ee9e42c173e3dce9e0b4636a9bf9a4a7e3a568667e8930b4909e330"
    sha256 cellar: :any,                 sonoma:        "9104ce59a639a75cc4434c61d20183ee824ebb32539f9e726d27d0ca2eecbd27"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5f2f9b253d2aba56063d78a0331c05f8fa9ef95ac1876277602caf4a827f2c75"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9f17f9d8168d8c5addb93501d676e8e1d1a79efd4c33da714dcea141f99674fb"
  end

  depends_on "cmake" => :build

  def install
    args = %W[
      -DBUILD_SHARED_LIBS=ON
      -DZXC_NATIVE_ARCH=OFF
      -DZXC_BUILD_TESTS=OFF
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    input = "Hello world"
    compressed = pipe_output(bin/"zxc", input)
    refute_empty compressed
    decompressed = pipe_output("#{bin}/zxc -d", compressed)
    assert_equal input, decompressed
  end
end