class CBlosc2 < Formula
  desc "Fast, compressed, persistent binary data store library for C"
  homepage "https://www.blosc.org"
  url "https://ghfast.top/https://github.com/Blosc/c-blosc2/archive/refs/tags/v3.3.0.tar.gz"
  sha256 "9659a54ef60278e80398c82c742b4e0ca0fbb85792fe9194df94ecfbec8f496b"
  license "BSD-3-Clause"
  compatibility_version 1
  head "https://github.com/Blosc/c-blosc2.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "204cd67083f14f2156327516311d029e37ffdb6a19a92650fc66c8d9fd0778d2"
    sha256 cellar: :any, arm64_sequoia: "c3ef1c9ef0ad89b21c7dff7b9219fabbbc2f8c16f6504e7e40a41128929ec0bc"
    sha256 cellar: :any, arm64_sonoma:  "0368d91878ca609b2d18d73cec8efbafa5e256ef71224fde3e705d75d492395d"
    sha256 cellar: :any, sonoma:        "1c1c803a30e42e0c88f82a43d0e3c06457ff14edb5386f8a8165263e46d81acd"
    sha256 cellar: :any, arm64_linux:   "66482172858bcd1a6bef53e25487f09a92763f6cfdfda358f102aac26940b139"
    sha256 cellar: :any, x86_64_linux:  "45875ce007761483d99dc792640291ceec7405b0f173c8098c0e4870fa9c6cc8"
  end

  depends_on "cmake" => :build
  depends_on "lz4"
  depends_on "zstd"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1400
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  fails_with :clang do
    build 1400
  end

  def install
    args = %w[
      -DBUILD_TESTS=OFF
      -DBUILD_FUZZERS=OFF
      -DBUILD_BENCHMARKS=OFF
      -DBUILD_EXAMPLES=OFF
      -DBUILD_PLUGINS=OFF
      -DPREFER_EXTERNAL_LZ4=ON
      -DPREFER_EXTERNAL_ZLIB=ON
      -DPREFER_EXTERNAL_ZSTD=ON
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "examples/simple.c"
  end

  test do
    system ENV.cc, pkgshare/"simple.c", "-I#{include}", "-L#{lib}", "-lblosc2", "-o", "test"
    assert_match "Successful roundtrip!", shell_output(testpath/"test")
  end
end