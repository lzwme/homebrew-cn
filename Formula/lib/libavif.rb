class Libavif < Formula
  desc "Library for encoding and decoding .avif files"
  homepage "https:github.comAOMediaCodeclibavif"
  url "https:github.comAOMediaCodeclibavifarchiverefstagsv1.0.3.tar.gz"
  sha256 "35e3cb3cd7158209dcc31d3bf222036de5b9597e368a90e18449ecc89bb86a19"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "05684332f217fdc56842b899e1d9feeb00489d65139250c1918b5e26b008f152"
    sha256 cellar: :any,                 arm64_ventura:  "477d4c23d42b680199eeac266a90aaba8e0d6fea55d250d2bc34cbf84d1207f1"
    sha256 cellar: :any,                 arm64_monterey: "52f9ce9c929cef31034f10f52d3eb37b46f474b3a4434e1053d83d9e418c058f"
    sha256 cellar: :any,                 sonoma:         "cf45d85b5b049ea41e78d22e3c1c6efd421e9c73652654879df364472cca7614"
    sha256 cellar: :any,                 ventura:        "920b6b769b9c9c53cab9e76e8be6bb4463776bb53e3c362d20bda87df65a28d0"
    sha256 cellar: :any,                 monterey:       "b7f7327ef73b496d9d870d453ae25e5a7af858d1fbd3e67d61a78e4fdb76e366"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ba31f42eca6a8322fe00556915ce5cc950d8599f5993a5658113a22cc74ebc40"
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
    system bin"avifenc", test_fixtures("test.png"), testpath"test.avif"
    assert_path_exists testpath"test.avif"

    system bin"avifdec", testpath"test.avif", testpath"test.jpg"
    assert_path_exists testpath"test.jpg"

    example = pkgshare"examplesavif_example_decode_file.c"
    system ENV.cc, example, "-I#{include}", "-L#{lib}", "-lavif", "-o", "avif_example_decode_file"
    output = shell_output("#{testpath}avif_example_decode_file #{testpath}test.avif")
    assert_match "Parsed AVIF: 8x8", output
  end
end