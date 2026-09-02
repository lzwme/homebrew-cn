class Mimalloc < Formula
  desc "Compact general purpose allocator"
  homepage "https://github.com/microsoft/mimalloc"
  url "https://ghfast.top/https://github.com/microsoft/mimalloc/archive/refs/tags/v3.5.1.tar.gz"
  sha256 "2602daad9b64b213a8835dee6fadda96d2081c0171bfcd3fb2db39bdc669d6b3"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "04061b0c7ebb7bc76c7e95d55ad2a6981ff22920f7886145c6b79588a6bc61ab"
    sha256 cellar: :any, arm64_sequoia: "bfd557dd21291ac97a557a2d7463c88b2e530683176a6afae51e4d518fd9fb8c"
    sha256 cellar: :any, arm64_sonoma:  "9f69376d4aa1f14ee26670227a2b7c51c1d1665d3bb5b3f99dc4a8232c0afd29"
    sha256 cellar: :any, arm64_linux:   "22005789b957987724f84502a38b200e8a7425142d48781d58679c8563feb201"
    sha256 cellar: :any, x86_64_linux:  "2c4f507d7d80e544f93d25ee850a0bf027f368d68aeb111d34f2406106c10cf6"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", "-DMI_INSTALL_TOPLEVEL=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "test"
  end

  test do
    cp pkgshare/"test/main.c", testpath
    system ENV.cc, "main.c", "-L#{lib}", "-lmimalloc", "-o", "test"
    assert_match(/pages\s+peak\s+total\s+current\s+block\s+total/, shell_output("./test 2>&1"))
  end
end