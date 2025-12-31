class Libheif < Formula
  desc "ISO/IEC 23008-12:2017 HEIF file format decoder and encoder"
  homepage "https://www.libde265.org/"
  url "https://ghfast.top/https://github.com/strukturag/libheif/releases/download/v1.21.0/libheif-1.21.0.tar.gz"
  sha256 "dc7cef4cf6a1c643eaebffd7b54190681f5b62d913eb6bc9769ad8dacd06b08b"
  license "LGPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4626782eed7d122c486da1dcdf9fb2f90d3bf15f80c09b45bb0c02f45f6b4d57"
    sha256 cellar: :any,                 arm64_sequoia: "8f9a68a4fd7baee08758531f00475853f8b904d0bc59aa3174ccf51fa64c50fd"
    sha256 cellar: :any,                 arm64_sonoma:  "96e94c3fe59d2a0d9e1befe020a23be9d7c5323ffd0030202a2e913104ee8729"
    sha256 cellar: :any,                 sonoma:        "6e6e7bed056b9805fa91598d30fbd0392236250afd7cba5bf83d492c75a1eaf7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f6f30ad7d77a4c521c3094f15a373b436c390434c68320b6278b02c859f0c59b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "888a8a74da4de9aee316f9df92013dc3c9324cb7a03f7ac98a532ce8ed012506"
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
    pkgshare.install "examples/example.heic"
    pkgshare.install "examples/example.avif"

    system "cmake", "-S", ".", "-B", "static", *args, *std_cmake_args, "-DBUILD_SHARED_LIBS=OFF"
    system "cmake", "--build", "static"
    lib.install "static/libheif/libheif.a"

    # Avoid rebuilding dependents that hard-code the prefix.
    inreplace lib/"pkgconfig/libheif.pc", prefix, opt_prefix
  end

  def post_install
    system Formula["shared-mime-info"].opt_bin/"update-mime-database", "#{HOMEBREW_PREFIX}/share/mime"
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