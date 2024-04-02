class CBlosc2 < Formula
  desc "Fast, compressed, persistent binary data store library for C"
  homepage "https:www.blosc.org"
  url "https:github.comBloscc-blosc2archiverefstagsv2.14.0.tar.gz"
  sha256 "e604f23ed5b6010810ae30413426622e2cf2ee81912c2f997e3a14993a4b7ec4"
  license "BSD-3-Clause"
  head "https:github.comBloscc-blosc2.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "0704eb91b776f6f852c85c2e1c69fd59bf130b83c3b61fd5097c518ec79782ec"
    sha256 cellar: :any,                 arm64_ventura:  "7ba70666de379505a705bfeef6ab06e59e0af2c8cc24d349751d152c776474bd"
    sha256 cellar: :any,                 arm64_monterey: "35bfa2d8816749ec38bca6cd0d6026a0f765745e7ea38116fa1fdce3878d4efb"
    sha256 cellar: :any,                 sonoma:         "882b9246f55ba4cc64970f183513a3f4026ca281c19a828e679259ce4f03f6a6"
    sha256 cellar: :any,                 ventura:        "b1c8cf336a72afb333bad63217616a0bef38150e1c08ce9172fdcad84fc2177b"
    sha256 cellar: :any,                 monterey:       "007c4605e33c29856c8c095edc2c581c1bfc7d73e98c381c367b0c65ddd81dc4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f78bb4031a627af2601eaf2976a77c60d4236b2d3de3d0cd4b8afc40c0601e32"
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

    pkgshare.install "examplessimple.c"
  end

  test do
    system ENV.cc, pkgshare"simple.c", "-I#{include}", "-L#{lib}", "-lblosc2", "-o", "test"
    assert_match "Successful roundtrip!", shell_output(testpath"test")
  end
end