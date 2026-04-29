class CBlosc2 < Formula
  desc "Fast, compressed, persistent binary data store library for C"
  homepage "https://www.blosc.org"
  url "https://ghfast.top/https://github.com/Blosc/c-blosc2/archive/refs/tags/v3.0.0.tar.gz"
  sha256 "32dca13fc25cd0c30a8557c5ee26ddb461d522d4257321d8d18c27e404646c53"
  license "BSD-3-Clause"
  compatibility_version 1
  head "https://github.com/Blosc/c-blosc2.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a6853f83323644eb3e5f37e6ec147c2d9e96534e2a9c508ccd6e280f61f49b45"
    sha256 cellar: :any,                 arm64_sequoia: "74682aca4b0bb18f1f2c5f35970c6335d52dc1a8a114a2c751dc318279a4d14f"
    sha256 cellar: :any,                 arm64_sonoma:  "f5d8aee23c8c6bdcb42fed4d43cf7f79c307a22ac0708dfd04c024e1da7206bc"
    sha256 cellar: :any,                 sonoma:        "9bbd3fc31a08d969bbc1531482cc52a0fe850ab02834636fe7973cb151f69b6a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "03389acd1dbc6edaeeb8c438c11b88fd75f695cefc9c47844d7dd43bedff8a10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f5daa80875307f2990615b51eb7eaeb8c1fd91ccf1c47890a7eca286ef262a92"
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