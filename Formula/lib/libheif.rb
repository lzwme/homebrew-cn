class Libheif < Formula
  desc "ISOIEC 23008-12:2017 HEIF file format decoder and encoder"
  homepage "https:www.libde265.org"
  url "https:github.comstrukturaglibheifreleasesdownloadv1.19.4libheif-1.19.4.tar.gz"
  sha256 "44c35b80596561ab531556175309f5f0ab3fcf7a7517dd933940574063f2af85"
  license "LGPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "79eb071bec943d0e8373f787f98dd52dfb1767a641276f07c1de8eefd379b82f"
    sha256 cellar: :any,                 arm64_sonoma:  "809f4f6c34b84d935066fc4a4dc1744918aed16b673711f9d2dbfa7f96464166"
    sha256 cellar: :any,                 arm64_ventura: "f8036615932e8e737cd23f0f65b0d9c319869325735932a7b73abe4adc2dbf44"
    sha256 cellar: :any,                 sonoma:        "735308e6dcc00ad1d9a02628a0e9ac23f773c05f0b5fcb57e34fc6895d6dfe69"
    sha256 cellar: :any,                 ventura:       "d2d26231ffc0384944a212c82006f29d8ce92a8b4bb2eedcc32c8c006aa29484"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7ba117314ebe9966b949e49a731ef6d1ca22b14d32469bd76e457df0be8f8ebd"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build

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
    assert_predicate testpath"exampleheic-1.jpg", :exist?
    assert_predicate testpath"exampleheic-2.jpg", :exist?

    output = "File contains 1 image"
    example = pkgshare"example.avif"
    exout = testpath"exampleavif.jpg"

    assert_match output, shell_output("#{bin}heif-convert #{example} #{exout}")
    assert_predicate testpath"exampleavif.jpg", :exist?
  end
end