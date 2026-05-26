class Libheif < Formula
  desc "ISO/IEC 23008-12:2017 HEIF file format decoder and encoder"
  homepage "https://www.libde265.org/"
  url "https://ghfast.top/https://github.com/strukturag/libheif/releases/download/v1.22.2/libheif-1.22.2.tar.gz"
  sha256 "eea48e4841f83fbe51d029337ffd2d14512d0203015dad40b90213d872958af3"
  license "LGPL-3.0-or-later"
  compatibility_version 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3742a19dc7df0bfc23c25da1cf02a22b6b93881641a51c8a07c34f7e15e32c26"
    sha256 cellar: :any,                 arm64_sequoia: "b945e91b53937c3004c2230ea31b442405b78c3d78c103f725c361894bdb1ca9"
    sha256 cellar: :any,                 arm64_sonoma:  "cf7234f7f494d9dc606e44772deaab906d75f5665542c27949fa7f7fc0b882f0"
    sha256 cellar: :any,                 sonoma:        "0ef8daff53f3c2103afaafc2e7fdaf2695454b9b957012bcce884958e1b1dbf2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e62a646b6ed98f8b9c6f749b9558b34df1c20e95bda4abd9075b90524f8d97f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9b4fd00ad20d6c5b5103402bbda83919da6603b67f7508633e466dace9fd343b"
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