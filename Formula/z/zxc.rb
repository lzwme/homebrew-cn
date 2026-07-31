class Zxc < Formula
  desc "High-performance asymmetric lossless compression library"
  homepage "https://github.com/hellobertrand/zxc"
  url "https://ghfast.top/https://github.com/hellobertrand/zxc/archive/refs/tags/v0.13.2.tar.gz"
  sha256 "957acf0e2c0f230b6acc0a4d48c3ee4734117b290a8c8ef1a9cf29686924a0ac"
  license "BSD-3-Clause"
  head "https://github.com/hellobertrand/zxc.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "d810ca9c17b55e017cd9e4c5ad3584743cd4c7c60a73212d661f1fcd95a23c1c"
    sha256 cellar: :any, arm64_sequoia: "bf053e266c31c229d56a588948d59f45e83ea650e70a0f5521646b7b7f0500ba"
    sha256 cellar: :any, arm64_sonoma:  "cc1e0f4d5c7f45ebd76a0a6ea2f8eae236780a0b94416cbc9bc4f982f35f916a"
    sha256 cellar: :any, sonoma:        "e0a758b2bc9c5c2aef1103e08ff1fa55deb813b293733a8b606b8abfb9d12008"
    sha256 cellar: :any, arm64_linux:   "3321eefd3885c418bcdb34ae16e77da5ae0f122fc5d1a2a5b995ee2a6cccc1d5"
    sha256 cellar: :any, x86_64_linux:  "c9e8a98f372117f2ae02f74b739eebc35dff289cbe20e1dcdbd5259665f6ddac"
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