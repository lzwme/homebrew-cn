class CBlosc2 < Formula
  desc "Fast, compressed, persistent binary data store library for C"
  homepage "https://www.blosc.org"
  url "https://ghfast.top/https://github.com/Blosc/c-blosc2/archive/refs/tags/v3.3.1.tar.gz"
  sha256 "c779eaca672e695989c420b5a8c736e49be5f056d9e196137b7ba22d8b8f5cdd"
  license "BSD-3-Clause"
  compatibility_version 1
  head "https://github.com/Blosc/c-blosc2.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "ce78b9e9db02ac4d94b722de78dd2f47154c94d8a494d2f781f436631c71e2da"
    sha256 cellar: :any, arm64_sequoia: "0381ec55306f189afc11668c7e478a16a4945b6676ba93b9b921706fd4a5e463"
    sha256 cellar: :any, arm64_sonoma:  "5778c17660e2bf3436204a88a4384638053461541f311624dfbb7fc3ac1cc7c1"
    sha256 cellar: :any, sonoma:        "a2136e3226b136643e2d9d087ea1c61943e687ad4d05c55644e705f20c3ebb2b"
    sha256 cellar: :any, arm64_linux:   "ffbe95a853209b3a3cf65a4ae9f9b16880a2605befbc72c44f7e1da8d166222d"
    sha256 cellar: :any, x86_64_linux:  "b2808aa152aa0bbc717d699e0c04322309062a2948dd5cb40dd7337e52b77aaf"
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