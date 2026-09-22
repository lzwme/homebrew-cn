class Libheif < Formula
  desc "ISO/IEC 23008-12:2017 HEIF file format decoder and encoder"
  homepage "https://www.libde265.org/"
  url "https://ghfast.top/https://github.com/strukturag/libheif/releases/download/v1.23.5/libheif-1.23.5.tar.gz"
  sha256 "fd9036064c4432f0550d15072ddf34956a248279ee9aeaff0fba3fa0f77d8f1a"
  license "LGPL-3.0-or-later"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "cf8ea3d502cb0a08e24a00a9c0334a3f53d2a158d07267cc925f1fa6f24f34b6"
    sha256 cellar: :any, arm64_tahoe:       "4944f53fcf6e0fa4b0e5d5b53dd8eda5fcd0bd9aff42afd001795d601b04fde7"
    sha256 cellar: :any, arm64_sequoia:     "63e961af49f4771ab5fc26253b97dbe5f9c6d5d578eb426c61e514d18a56a8a8"
    sha256 cellar: :any, arm64_linux:       "abac0483660fe7bf25062207bf0d45a2b5289d29b2c7aa66ec3bba7706b5a3cc"
    sha256 cellar: :any, x86_64_linux:      "4bfeff1ebb3fd6112ee116475413fe29b59008e6ee7c6d85d3e3018e38fbf130"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

  depends_on "aom"
  depends_on "jpeg-turbo"
  depends_on "libde265"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "webp"
  depends_on "x265"

  def install
    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DPLUGIN_DIRECTORY=#{HOMEBREW_PREFIX}/lib/libheif
      -DPLUGIN_INSTALL_DIRECTORY=#{lib}/libheif
      -DWITH_DAV1D=OFF
      -DWITH_EXAMPLE_HEIF_VIEW=OFF
      -DWITH_GDK_PIXBUF=OFF
      -DWITH_OpenH264_DECODER=OFF
      -DWITH_RAV1E=OFF
      -DWITH_SvtEnc=OFF
      -DWITH_X264=OFF
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "examples/example.heic"
    pkgshare.install "examples/example.avif"

    system "cmake", "-S", ".", "-B", "static", *args, *std_cmake_args, "-DBUILD_SHARED_LIBS=OFF"
    system "cmake", "--build", "static"
    lib.install "static/libheif/libheif.a"

    # Avoid rebuilding dependents that hard-code the prefix.
    inreplace lib/"pkgconfig/libheif.pc", prefix, opt_prefix
  end

  def caveats
    "Additional codecs can be enabled by `brew install libheif-plugins`"
  end

  test do
    output = "File contains 2 images"
    example = pkgshare/"example.heic"
    exout = testpath/"exampleheic.jpg"

    assert_match output, shell_output("#{bin}/heif-convert #{example} #{exout}")
    assert_path_exists testpath/"exampleheic-1.jpg"
    assert_path_exists testpath/"exampleheic-2.jpg"

    output = "File contains 1 image"
    example = pkgshare/"example.avif"
    exout = testpath/"exampleavif.jpg"

    assert_match output, shell_output("#{bin}/heif-convert #{example} #{exout}")
    assert_path_exists testpath/"exampleavif.jpg"
  end
end