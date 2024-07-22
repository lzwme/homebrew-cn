class Libavif < Formula
  desc "Library for encoding and decoding .avif files"
  homepage "https:github.comAOMediaCodeclibavif"
  url "https:github.comAOMediaCodeclibavifarchiverefstagsv1.1.0.tar.gz"
  sha256 "edb31951005d7a143be1724f24825809599a4832073add50eaf987733defb5c8"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b645d64337fa29544813352646f9b7e9f246b6dea71d647fb30dd40d4fe01586"
    sha256 cellar: :any,                 arm64_ventura:  "f51f6a14ef8c74ecfdb990f96f9618f443f8ca321af9063bda7a6d5d3cee0a4c"
    sha256 cellar: :any,                 arm64_monterey: "44280495b03b130e4c94c2aa3349fb1b78c18c6c4c95f13d74841d62029d969a"
    sha256 cellar: :any,                 sonoma:         "9a69f7138f63910a9ed08fcf04035a5cd49b7df0b32fd32c98cbea9da83a4b40"
    sha256 cellar: :any,                 ventura:        "00ab81273cfc5712185d500d98c2b44f4c56701a73d24544720a3b014aa24d87"
    sha256 cellar: :any,                 monterey:       "3447e663005ab378c7a5f0c4b5a689adce24ddcfb12c66526a88258da8294dc8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8e6fd8240b27c3a778668a9428178962b67c3b52941364d8423984d57d34432c"
  end

  depends_on "cmake" => :build
  depends_on "nasm" => :build
  depends_on "aom"
  depends_on "jpeg-turbo"
  depends_on "libpng"

  uses_from_macos "zlib"

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