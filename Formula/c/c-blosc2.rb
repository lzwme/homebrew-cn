class CBlosc2 < Formula
  desc "Fast, compressed, persistent binary data store library for C"
  homepage "https://www.blosc.org"
  url "https://ghfast.top/https://github.com/Blosc/c-blosc2/archive/refs/tags/v2.21.1.tar.gz"
  sha256 "69bd596bc4c64091df89d2a4fbedc01fc66c005154ddbc466449b9dfa1af5c05"
  license "BSD-3-Clause"
  head "https://github.com/Blosc/c-blosc2.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "0c68524388a593fd3e87457dbe4759e7202a8270959a234400151205d758ddb2"
    sha256 cellar: :any,                 arm64_sonoma:  "feb64e0c4982a97221ab22ffe268a52d002c21e144b9c99f2072fcb3217fb2d0"
    sha256 cellar: :any,                 arm64_ventura: "252ebef6ad599073329cb5a87dd618e82b4dbd9f9da34590351072fe2d596c02"
    sha256 cellar: :any,                 sonoma:        "f385ccb06aa2176bd03c6c78f515c680d6f1a8017217a654fe150e58b7a23abf"
    sha256 cellar: :any,                 ventura:       "84b775ceadcb2045ab46d59f06dcae9179dda3ff9a044e463a180788a24360d5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cd359a6dc272ed15eb5e9dc96af927122a898e071963df46502d6a8ea5c28c4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e2d2225aae3e2bf46a549107d11efd5fe46d8b539d65025f40317aa1e2a8be3d"
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

    internal_complibs = buildpath.glob("internal-complibs/{lz4,zlib,zstd}-*")
    odie "Failed to find vendored sources for removal!" if internal_complibs.count != 3
    rm_r internal_complibs

    args = %w[
      -DBUILD_TESTS=OFF
      -DBUILD_FUZZERS=OFF
      -DBUILD_BENCHMARKS=OFF
      -DBUILD_EXAMPLES=OFF
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