class Libavif < Formula
  desc "Library for encoding and decoding .avif files"
  homepage "https://github.com/AOMediaCodec/libavif"
  url "https://ghproxy.com/https://github.com/AOMediaCodec/libavif/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "410f85cf0d13f403b41197c0774da469f5d73b89aa06d40fc726165377f215a0"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "76070a66979942ef18513ad6c972c9c1e6075e8fd869215f2c4698d483c3c680"
    sha256 cellar: :any,                 arm64_monterey: "bd3e7b4974f96a2b22e504b82e00b69623a22ce71a93668157c59f0a12108100"
    sha256 cellar: :any,                 arm64_big_sur:  "1ba88f4e7dbd8cc738a609a4d1037777d6d30663c984a01e1a7bcc3858bc5344"
    sha256 cellar: :any,                 ventura:        "b29b3cf4472037702041b759478b8ae0652adac8cd4d3507bfcb73c837377f7d"
    sha256 cellar: :any,                 monterey:       "cf033a07e21c5d6ba808233a61769fe34d578043dbb1f0ce143f6b4a3a7eb444"
    sha256 cellar: :any,                 big_sur:        "f478699a85ae54ee873703295c1a7ff795a1946a20f3105953e458cd2d13a26c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d734c6a76e0502ff13e33ac4d6f4c90a191d479b474002b714b634c6518420ae"
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