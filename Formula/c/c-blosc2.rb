class CBlosc2 < Formula
  desc "Fast, compressed, persistent binary data store library for C"
  homepage "https://www.blosc.org"
  url "https://ghfast.top/https://github.com/Blosc/c-blosc2/archive/refs/tags/v2.21.1.tar.gz"
  sha256 "69bd596bc4c64091df89d2a4fbedc01fc66c005154ddbc466449b9dfa1af5c05"
  license "BSD-3-Clause"
  head "https://github.com/Blosc/c-blosc2.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "610dd997a3f8490fd975a97f976d192a21ffc20aa596d6e786b98f554e80e207"
    sha256 cellar: :any,                 arm64_sonoma:  "2e00493980d0d15f1e99596489a32f707d45cfb2fb781666838fe69071bdebf9"
    sha256 cellar: :any,                 arm64_ventura: "fc4b4755be8d055179e6726e58958586238b5a7bd4614e040897ab26c4658f83"
    sha256 cellar: :any,                 sonoma:        "883aa56af9a4790946ef89b5ce8b3acbc8663024644fed7c23c7ed3593d646c3"
    sha256 cellar: :any,                 ventura:       "aac572cc58f2e7fdbd41d2882f7550185f50eb41a9bec2f9a68dddd28c08e69b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b508e370bbbb8a38db2bf067724b9c66e701bd20bf1e504db8842dca3ef4bb73"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3338fe14f333aeaca457840638e05ab8941d7d442055bba5af9d08a3f3d8e767"
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