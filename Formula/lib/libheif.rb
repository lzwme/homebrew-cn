class Libheif < Formula
  desc "ISOIEC 23008-12:2017 HEIF file format decoder and encoder"
  homepage "https:www.libde265.org"
  url "https:github.comstrukturaglibheifreleasesdownloadv1.20.0libheif-1.20.0.tar.gz"
  sha256 "b2e08489b0c4a9d7ec44e546ee1e0c1ed9f5de066414d88d868987641eeee564"
  license "LGPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "72bee6fcc08bc1f6fc00ed417c27dd09669ca3c1a099f270cafb8fce03368fe8"
    sha256 cellar: :any,                 arm64_sonoma:  "8d66a2b4634225884af817ad4b3ea507f015a6b012db32c54cb5069f84799c15"
    sha256 cellar: :any,                 arm64_ventura: "9a475aeb0fae173c48fa06ad80bcd2c0b5e7f840a7a11d3471915f1770ba9d3e"
    sha256 cellar: :any,                 sonoma:        "306f8bbfb7f27277d2c104b85e1b0d3287fb8e97ac8ac8c62b081653a3593e9a"
    sha256 cellar: :any,                 ventura:       "8136679044a9f28fedfdbb9bc2ae96014b8f406d2f8b0e0970b4b84846699812"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d1597b9246554ae0b3467be6d6c3cf5d9e0496352d128fd208a63c81774c5823"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c3ae853837369f146e5d54bea5510eeba17f449e99d269a968b9842aaf34dde9"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

  depends_on "aom"
  depends_on "jpeg-turbo"
  depends_on "libde265"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "shared-mime-info"
  depends_on "webp"
  depends_on "x265"

  def install
    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DWITH_DAV1D=OFF
      -DWITH_GDK_PIXBUF=OFF
      -DWITH_RAV1E=OFF
      -DWITH_SvtEnc=OFF
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "examplesexample.heic"
    pkgshare.install "examplesexample.avif"

    system "cmake", "-S", ".", "-B", "static", *args, *std_cmake_args, "-DBUILD_SHARED_LIBS=OFF"
    system "cmake", "--build", "static"
    lib.install "staticlibheiflibheif.a"

    # Avoid rebuilding dependents that hard-code the prefix.
    inreplace lib"pkgconfiglibheif.pc", prefix, opt_prefix
  end

  def post_install
    system Formula["shared-mime-info"].opt_bin"update-mime-database", "#{HOMEBREW_PREFIX}sharemime"
  end

  test do
    output = "File contains 2 images"
    example = pkgshare"example.heic"
    exout = testpath"exampleheic.jpg"

    assert_match output, shell_output("#{bin}heif-convert #{example} #{exout}")
    assert_path_exists testpath"exampleheic-1.jpg"
    assert_path_exists testpath"exampleheic-2.jpg"

    output = "File contains 1 image"
    example = pkgshare"example.avif"
    exout = testpath"exampleavif.jpg"

    assert_match output, shell_output("#{bin}heif-convert #{example} #{exout}")
    assert_path_exists testpath"exampleavif.jpg"
  end
end