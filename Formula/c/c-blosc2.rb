class CBlosc2 < Formula
  desc "Fast, compressed, persistent binary data store library for C"
  homepage "https:www.blosc.org"
  url "https:github.comBloscc-blosc2archiverefstagsv2.17.0.tar.gz"
  sha256 "f8d5b7167f6032bc286b4de63a7feae281d1845d962edcfa21d81a025eef2bb2"
  license "BSD-3-Clause"
  head "https:github.comBloscc-blosc2.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c1c2f86f261cc31f6def5abaf8edc8180eaa401512a2123caf10b6def7a599c7"
    sha256 cellar: :any,                 arm64_sonoma:  "24bb535454241a339692d86ee2c6cf8e594bba7c2e667958a0d9531ffc034dab"
    sha256 cellar: :any,                 arm64_ventura: "87fad3d9f01a6b3a6875a863b716b7c3c94f4a88b632ebcf7d14d54f00fa91de"
    sha256 cellar: :any,                 sonoma:        "3dad5b1fbac9f11ba573f7d6705cc9ada47bb190380b72c31844606b9195c01d"
    sha256 cellar: :any,                 ventura:       "a599182a883be6c842874df5efb6d0620c6eca30c2679e81e17fa5fc43949d08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8f780bb9ba93e846788dc7ed5044563fb59293bfb028e8d01e177b3ccf8e7537"
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