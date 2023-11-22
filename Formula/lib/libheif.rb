class Libheif < Formula
  desc "ISO/IEC 23008-12:2017 HEIF file format decoder and encoder"
  homepage "https://www.libde265.org/"
  url "https://ghproxy.com/https://github.com/strukturag/libheif/releases/download/v1.17.4/libheif-1.17.4.tar.gz"
  sha256 "3619c092992eb5ccaf7795cbdc8ac70f96ab0f20fc5681fcef6ff5fec027a838"
  license "LGPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "45dbe8bd67f870d48907d38155a8c99261a86e1404fcbac1a58432a33b0241de"
    sha256 cellar: :any,                 arm64_ventura:  "a3a75ea9f234fde29bbddb4a2cb2c324ed66ce2296cf11be11648873e0f4748a"
    sha256 cellar: :any,                 arm64_monterey: "a0244f8287999f3c9319a18cbde73342313a4b01f203a2a7fae7a2125bd057bc"
    sha256 cellar: :any,                 sonoma:         "0d301543408d0927d466f2940ab0e5c366c6bacbb9f2302b973c624b1be738f3"
    sha256 cellar: :any,                 ventura:        "975573c0bf9fe870a72ff006ae91927aa6b49bf6f12e5ba29a6b18b3b3742eab"
    sha256 cellar: :any,                 monterey:       "06f28c609069f3459a2de60ad99b2c775d12a28f7c6bda5329f9a6b1e0221ab0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c2184999236cdbd8f3db5a49db354660b58d16f7f5b751b231b7f42924e0018"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "aom"
  depends_on "jpeg-turbo"
  depends_on "libde265"
  depends_on "libpng"
  depends_on "shared-mime-info"
  depends_on "x265"

  def install
    args = %W[
      -DWITH_RAV1E=OFF
      -DWITH_DAV1D=OFF
      -DWITH_SvtEnc=OFF
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "examples/example.heic"
    pkgshare.install "examples/example.avif"
    system "cmake", "-S", ".", "-B", "static", *args, *std_cmake_args, "-DBUILD_SHARED_LIBS=OFF"
    system "cmake", "--build", "static"
    lib.install "static/libheif/libheif.a"
  end

  def post_install
    system Formula["shared-mime-info"].opt_bin/"update-mime-database", "#{HOMEBREW_PREFIX}/share/mime"
  end

  test do
    output = "File contains 2 images"
    example = pkgshare/"example.heic"
    exout = testpath/"exampleheic.jpg"

    assert_match output, shell_output("#{bin}/heif-convert #{example} #{exout}")
    assert_predicate testpath/"exampleheic-1.jpg", :exist?
    assert_predicate testpath/"exampleheic-2.jpg", :exist?

    output = "File contains 1 image"
    example = pkgshare/"example.avif"
    exout = testpath/"exampleavif.jpg"

    assert_match output, shell_output("#{bin}/heif-convert #{example} #{exout}")
    assert_predicate testpath/"exampleavif.jpg", :exist?
  end
end