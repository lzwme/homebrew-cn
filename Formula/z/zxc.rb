class Zxc < Formula
  desc "High-performance asymmetric lossless compression library"
  homepage "https://github.com/hellobertrand/zxc"
  url "https://ghfast.top/https://github.com/hellobertrand/zxc/archive/refs/tags/v0.8.3.tar.gz"
  sha256 "6422427613178b8543d2f6ad08c3a5327c9087381dcda707f70e18d84215f136"
  license "BSD-3-Clause"
  head "https://github.com/hellobertrand/zxc.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "637a11622ad33dc1b2aa6d552ea92d34b1dce5b9e53bcfbf6b46f3d808548b98"
    sha256 cellar: :any,                 arm64_sequoia: "74dc1cdd8e3a74bc7eb0ba40d369e35fbbd82d54b964a0a31a323243abfa3184"
    sha256 cellar: :any,                 arm64_sonoma:  "d4ebc84041ad66af46f617707e4f57a69e791710602bceca7da7ea86b7c21109"
    sha256 cellar: :any,                 sonoma:        "6c304ca798bea13f7eccf692f15b8f250c6a991787712597435d8bf271bced03"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fc199288202235f4d3cc8e6a20373ea2ba9569c74fd8b4b4931c514a9ef503ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "58393ba17bc31bf08c5e33f3d43f4ab20141c97af23d40d5bb67f055f3916a75"
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