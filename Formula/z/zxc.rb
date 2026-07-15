class Zxc < Formula
  desc "High-performance asymmetric lossless compression library"
  homepage "https://github.com/hellobertrand/zxc"
  url "https://ghfast.top/https://github.com/hellobertrand/zxc/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "2e7f960c37c8c0225bba122d17dcefda1597f3a98e9822611a6963416b769e8b"
  license "BSD-3-Clause"
  head "https://github.com/hellobertrand/zxc.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "9839b369bbe1abf992df74b4ee82a5c333f87e25f0a39806fe500a1f8f1b82f2"
    sha256 cellar: :any, arm64_sequoia: "580d6d38bfa4900c9663c2720c9a4dbb6b77544fbe7e54e39c710409560de4fa"
    sha256 cellar: :any, arm64_sonoma:  "4f9c2ee140e548ea9670f7552f4516b8f05b5d6ef45f627852ef4566bd3deca4"
    sha256 cellar: :any, sonoma:        "1e74f0104351838732fa02591d4a5f310404fb002c4120df741c2528279e5a72"
    sha256 cellar: :any, arm64_linux:   "89f09f533ad6850d04e1098afe63ea4d253fc4d32de8c94f9067d5c4e557a4a6"
    sha256 cellar: :any, x86_64_linux:  "c05353c32f7ef4050795761c6ba377a66efbb51ac2fcb55f7a5965f03a3d15da"
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