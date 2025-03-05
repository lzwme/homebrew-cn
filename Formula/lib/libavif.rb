class Libavif < Formula
  desc "Library for encoding and decoding .avif files"
  homepage "https:github.comAOMediaCodeclibavif"
  url "https:github.comAOMediaCodeclibavifarchiverefstagsv1.2.0.tar.gz"
  sha256 "2182f4900d1a9617cee89746922a58dd825f2a3547f23907b8d78dc3685f7d8c"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "9710e3232886b071086be9e829ed33cd2adab962a021384d9aa9d09e585d23d4"
    sha256 cellar: :any,                 arm64_sonoma:  "4011a89e3ff4ff9679994aeed8b1d9a9b0c43a4147685f5cc7e48d8dc28e95e7"
    sha256 cellar: :any,                 arm64_ventura: "365a31ff1a0b7dcff98b7744231fc3b0c702d37a817d549367078a025d04ce03"
    sha256 cellar: :any,                 sonoma:        "499ead99a083721c808997faf3698d61b300db23d8048f9e45abbe882cc3ea8c"
    sha256 cellar: :any,                 ventura:       "7874295d5f1e1916a3d0a832d99aa6a9f3960025d4cad0ff9c70bfc44ad1d92c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7e236e3c9182095c5b944fcbda529735fcef4c8afc67909bae93b84a71a85c37"
  end

  depends_on "cmake" => :build
  depends_on "nasm" => :build
  depends_on "aom"
  depends_on "jpeg-turbo"
  depends_on "libpng"

  uses_from_macos "zlib"

  # Review for removal on 1.2.1 release
  # https:github.comAOMediaCodeclibavifissues2653
  patch do
    url "https:github.comAOMediaCodeclibavifcommit7cc1dccabd45864dc0945882faa0348dcded847f.patch?full_index=1"
    sha256 "904feeb044dc3e8dc9029764125333bcd3a48e400691f9c67f64929ab20cff89"
  end

  def install
    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DAVIF_CODEC_AOM=SYSTEM
      -DAVIF_BUILD_APPS=ON
      -DAVIF_BUILD_EXAMPLES=OFF
      -DAVIF_BUILD_TESTS=OFF
      -DAVIF_LIBYUV=OFF
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
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