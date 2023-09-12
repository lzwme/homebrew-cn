class Binaryen < Formula
  desc "Compiler infrastructure and toolchain library for WebAssembly"
  homepage "https://webassembly.org/"
  url "https://ghproxy.com/https://github.com/WebAssembly/binaryen/archive/version_115.tar.gz"
  sha256 "8682b98e8c6ec8e52425e77a8256e226ffc8b3436f3ef37c442f3d1bee5f7880"
  license "Apache-2.0"
  head "https://github.com/WebAssembly/binaryen.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "6aae83084d95882d886801f0286c574377d63980fd1765e341794078357c78b7"
    sha256 cellar: :any,                 arm64_monterey: "c16eff4a742a4e9e9f97ce01d7223bc23181349f0ba306654a83da18dbd86e71"
    sha256 cellar: :any,                 arm64_big_sur:  "ec794186d157f28f5cf35f28dacaa442e1e3c7427c3c31a61924c75eef0d1bd3"
    sha256 cellar: :any,                 ventura:        "9db17800cac9c1c2855400be8f90a68bcbd203d2b703b090983c836bfad98ec8"
    sha256 cellar: :any,                 monterey:       "5b937f33c038115402eb64e046cbb817baf39cbbccda8deca4d3860c9eb877da"
    sha256 cellar: :any,                 big_sur:        "f48526ebfbb5bf11142580aea44059990ebf8470be9e0861e00354b982fd3da3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b0aabb4f9fce4605255c5e13c3c20164811fc8d47dd96ba00eb8a99828c2913e"
  end

  depends_on "cmake" => :build
  depends_on macos: :mojave # needs std::variant

  fails_with :gcc do
    version "6"
    cause "needs std::variant"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, "-DBUILD_TESTS=false"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "test/"
  end

  test do
    system bin/"wasm-opt", "-O", pkgshare/"test/passes/O1_print-stack-ir.wast", "-o", "1.wast"
    assert_match "stacky-help", (testpath/"1.wast").read
  end
end