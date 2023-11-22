class Libavif < Formula
  desc "Library for encoding and decoding .avif files"
  homepage "https://github.com/AOMediaCodec/libavif"
  url "https://ghproxy.com/https://github.com/AOMediaCodec/libavif/archive/refs/tags/v1.0.2.tar.gz"
  sha256 "de8bf79488c5b523b77358df8b85ae69c3078e6b3f1636fc1f313f952269ad20"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "9498e1c4b5fd9bb02da2b90f466feb5d78b45a569c6e553b1b12daba8571d79d"
    sha256 cellar: :any,                 arm64_ventura:  "abab3d91c1501bab1da3555e53276b5abb860680899919347321b2a2af4eb452"
    sha256 cellar: :any,                 arm64_monterey: "6e06e710e9d263412d3582616ab40bc8154fc8daec77ca5984d192ce890021b5"
    sha256 cellar: :any,                 sonoma:         "5d5c5d23f5e474ef2a02c11e9906cf93f6b88207b5ec6e72432267d265098af8"
    sha256 cellar: :any,                 ventura:        "c3cb1feee44f42cad08ae274782eb47ca171a4121e94dbc6310e00043eb44145"
    sha256 cellar: :any,                 monterey:       "5a73d0d5e70fd0ffcc0ac84b35fe9e1054550bbb584eb890c4b62996eb195352"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "644870d2e4af9fff6408f8ef23cb58573aa377bb8ef2e6d4b2381cb9d42e9096"
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