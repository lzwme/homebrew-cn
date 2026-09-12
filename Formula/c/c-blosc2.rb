class CBlosc2 < Formula
  desc "Fast, compressed, persistent binary data store library for C"
  homepage "https://www.blosc.org"
  url "https://ghfast.top/https://github.com/Blosc/c-blosc2/archive/refs/tags/v3.3.4.tar.gz"
  sha256 "db6ba3ee4f863a3c15794fbba99a4e5704d6a01017799628546152c8f4b06818"
  license "BSD-3-Clause"
  compatibility_version 1
  head "https://github.com/Blosc/c-blosc2.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "9f1716bcf80dc784c76d0ab126649f92a34ad7ad4d214f0aa769285799737945"
    sha256 cellar: :any, arm64_tahoe:       "af2b8fc8734bbb2be1fd7f4946d9372ca3f9344d55e055a5902fda541427bbf9"
    sha256 cellar: :any, arm64_sequoia:     "6141f3696fa403a767ae598b4745ea40bb48802ebb9edfc84345eb890cd3f3ab"
    sha256 cellar: :any, arm64_linux:       "07676187feb9e434725dca0ae4feeb0c9b4df9b3240ef52d5a7c9c2eda1060cc"
    sha256 cellar: :any, x86_64_linux:      "acbec52d743132d92107fb1045ed4eab6e82afb3f439f898e8745e4a3a1e1998"
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