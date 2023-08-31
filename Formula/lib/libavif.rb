class Libavif < Formula
  desc "Library for encoding and decoding .avif files"
  homepage "https://github.com/AOMediaCodec/libavif"
  url "https://ghproxy.com/https://github.com/AOMediaCodec/libavif/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "398fe7039ce35db80fe7da8d116035924f2c02ea4a4aa9f4903df6699287599c"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "044695408924ba007b0d4ed5c37bdb609506bcdc4e58adde06a3bda6418aebc0"
    sha256 cellar: :any,                 arm64_monterey: "7ddfcba784b0f96a9ae9e6502bd37c783e16f9f10cc52bc00028e859b2cbfd69"
    sha256 cellar: :any,                 arm64_big_sur:  "508783fd212b0daa97487d1ba075ffab6cdd35280f20216fe1a565456c570c7c"
    sha256 cellar: :any,                 ventura:        "b8e5bef8eaee1eebe6365e3f04ae1ce8f537c99482d414c3b606d9f8a26157a6"
    sha256 cellar: :any,                 monterey:       "713f393dfba18c8d48b9a798775ccb0e7f488038e091a46890c1b6981c78c070"
    sha256 cellar: :any,                 big_sur:        "3a807baae421db708ef8497c0764ce54f18e7c81ece4604207d734fe291eb6d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d0e05c23ac6188951d52c803cc40b76c0e87e999bd082267263f3aba99baa6f9"
  end

  depends_on "cmake" => :build
  depends_on "nasm" => :build
  depends_on "aom"
  depends_on "jpeg-turbo"
  depends_on "libpng"

  uses_from_macos "zlib"

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    "-DAVIF_CODEC_AOM=ON",
                    "-DAVIF_BUILD_APPS=ON",
                    "-DAVIF_BUILD_EXAMPLES=OFF",
                    "-DAVIF_BUILD_TESTS=OFF",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "examples"
  end

  test do
    system bin/"avifenc", test_fixtures("test.png"), testpath/"test.avif"
    assert_path_exists testpath/"test.avif"

    system bin/"avifdec", testpath/"test.avif", testpath/"test.jpg"
    assert_path_exists testpath/"test.jpg"

    example = pkgshare/"examples/avif_example_decode_file.c"
    system ENV.cc, example, "-I#{include}", "-L#{lib}", "-lavif", "-o", "avif_example_decode_file"
    output = shell_output("#{testpath}/avif_example_decode_file #{testpath}/test.avif")
    assert_match "Parsed AVIF: 8x8", output
  end
end