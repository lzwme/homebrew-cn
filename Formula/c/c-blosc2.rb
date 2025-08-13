class CBlosc2 < Formula
  desc "Fast, compressed, persistent binary data store library for C"
  homepage "https://www.blosc.org"
  url "https://ghfast.top/https://github.com/Blosc/c-blosc2/archive/refs/tags/v2.20.0.tar.gz"
  sha256 "499e881f9fd868cbbaba69bc6d27d82b2d72ef22c998691d60e8b3c3ef0be459"
  license "BSD-3-Clause"
  head "https://github.com/Blosc/c-blosc2.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "05853eee61fce98a4bf78ed962262eea2e1d921c75dc52ddb2f4ff2d399d7ccf"
    sha256 cellar: :any,                 arm64_sonoma:  "f627bb3abd4235d767143aa6bfca09175bba5decaa9cee010c8a2d5cd2ecbee1"
    sha256 cellar: :any,                 arm64_ventura: "4e9e5d34155d02b030e1f2bf46e43082bf1fff9c2343dac7a9652c98a08fc858"
    sha256 cellar: :any,                 sonoma:        "e8cb81d2916090166d055c2bb1616b9cf8b2277db12584c66027fbd060c122a6"
    sha256 cellar: :any,                 ventura:       "f271438d9600e1e88db8a2442dbebbbb6127690f6b0fa296c1039e43460e72bd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3b709f0796472624d3aa4c9c6faa1c3e8eaeb5b87ce8cce34c948ec945417e01"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f4a8540a28fb7b6e5f9c3f677c34ab42cbc6791126c3c43ed5578ffb44155fd2"
  end

  depends_on "cmake" => :build
  depends_on "lz4"
  depends_on "zstd"

  uses_from_macos "zlib"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1400
  end

  def install
    ENV.llvm_clang if OS.mac? && DevelopmentTools.clang_build_version <= 1400

    args = %w[
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