class Mimalloc < Formula
  desc "Compact general purpose allocator"
  homepage "https://github.com/microsoft/mimalloc"
  url "https://ghfast.top/https://github.com/microsoft/mimalloc/archive/refs/tags/v3.5.4.tar.gz"
  sha256 "36e9b5bf1bb703567a0347491721ce2098000db8284dc55cd53d211452723cdb"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "dd60b93e8d14d142676e8fadc8716a3a89fd904e70ae64f8b7b37419dd841163"
    sha256 cellar: :any, arm64_tahoe:       "16044798f74dc1afe43cf92bad17c8e6dd72c45b59e3e8f3ba31bb26914c3be7"
    sha256 cellar: :any, arm64_sequoia:     "ed6ea628573310aaf4b84ca7fa1beb6adc70c0da47461d2cec75cf56373e9e79"
    sha256 cellar: :any, arm64_linux:       "d1355a4f11b003abd071ad5dcc86a5f568349b61eb67c4f15db6f053b0936eb1"
    sha256 cellar: :any, x86_64_linux:      "8bb224b5ff42420711e3e550be105fb3496e46945c95c46177cd3d792a94bf5b"
  end

  depends_on "cmake" => :build

  deny_network_access!

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