class CBlosc2 < Formula
  desc "Fast, compressed, persistent binary data store library for C"
  homepage "https://www.blosc.org"
  url "https://ghfast.top/https://github.com/Blosc/c-blosc2/archive/refs/tags/v3.1.0.tar.gz"
  sha256 "af1c1141decdccc628360629f1a79b35da47fbc977efe13c28b3a3d193689491"
  license "BSD-3-Clause"
  compatibility_version 1
  head "https://github.com/Blosc/c-blosc2.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e8164c9a23d520298da07505bf76752c22014978ce01a6c6bfacc8bbe6cfbece"
    sha256 cellar: :any,                 arm64_sequoia: "654b1ac42879c6d0b12383d2fd497eacb23108e836653feac354f46a8f67213f"
    sha256 cellar: :any,                 arm64_sonoma:  "e08a6cce86515013bfa185974e906f15dccd9c7e092a370ba39877338971626c"
    sha256 cellar: :any,                 sonoma:        "ae0d15d2448ab32cc68b43a9beb834f8c31601285f7a1cab14f582061e3fb127"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9f5e461998b5177b24aada160c57778208d092706f68cea6d8e432d38f79a8ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0038fc8ba7321a8f1f93f3e14d88308ecc831d35e682b36a15132c1024fa7e46"
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