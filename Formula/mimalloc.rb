class Mimalloc < Formula
  desc "Compact general purpose allocator"
  homepage "https://github.com/microsoft/mimalloc"
  url "https://ghproxy.com/https://github.com/microsoft/mimalloc/archive/refs/tags/v2.0.9.tar.gz"
  sha256 "4a29edae32a914a706715e2ac8e7e4109e25353212edeed0888f4e3e15db5850"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "1bf1120e8812645cadebf4c92996d85d1b8009f58403c653d69e4da78a9ae259"
    sha256 cellar: :any,                 arm64_monterey: "e207c935a04d622ca0b6c596e63c8c0069d11f7db6dda0a4c837ee7928c680af"
    sha256 cellar: :any,                 arm64_big_sur:  "fc13bbdb901db573f4ab7d9f015ee830007276ef67b89352c65141345a77e5d5"
    sha256 cellar: :any,                 ventura:        "6b54f4338b1666c4e61bcc8f09ea35a6957078a6202bf1f8a806b2fa2ccb0546"
    sha256 cellar: :any,                 monterey:       "3f06858520cb0cf131ba12c747309ad965722160909f4fa76540bb4906c19c9b"
    sha256 cellar: :any,                 big_sur:        "bc23c9bbbe1bc651b4775743af56ea5560a42bff4b0a5695a4d927e8c661955b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "33ce5deb809b4a863fd0ff3d57d1184a97a1cebf413125d16f029767abd9c801"
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
    assert_match "heap stats", shell_output("./test 2>&1")
  end
end