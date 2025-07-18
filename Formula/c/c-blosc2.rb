class CBlosc2 < Formula
  desc "Fast, compressed, persistent binary data store library for C"
  homepage "https://www.blosc.org"
  url "https://ghfast.top/https://github.com/Blosc/c-blosc2/archive/refs/tags/v2.19.1.tar.gz"
  sha256 "cb645982acfeccc8676bc4f29859130593ec05f7f9acf62ebd4f1a004421fa28"
  license "BSD-3-Clause"
  head "https://github.com/Blosc/c-blosc2.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3c7f96d992a236e359ddb16f50b9441ea82b197cb189a4979051d534888f3d95"
    sha256 cellar: :any,                 arm64_sonoma:  "017b6683e08908871a6b9ce2e670a039be1541f02cd4ea6d2af3e69f466e5187"
    sha256 cellar: :any,                 arm64_ventura: "c64f5fab87b2c5eece5a8160b3298b1259085d686267503a0a200074f58a052b"
    sha256 cellar: :any,                 sonoma:        "71a7fec7ceb63e8ed39516218bd7725a7e15c98b80d4e23719d62e3cff75b348"
    sha256 cellar: :any,                 ventura:       "0e897567f27ba3d68213da351004840f5ac1e51f41041e17c89118a5827c8b73"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f24e048b0bd08203426f7c016b499fb94e0eabd9dbabea6f6f27266115693f13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "842bdde2b5d1923f00065876874db8dbeecd1fb97c7a357cec3bb743f39dbca5"
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