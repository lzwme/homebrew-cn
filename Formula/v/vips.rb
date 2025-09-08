class Vips < Formula
  desc "Image processing library"
  homepage "https://github.com/libvips/libvips"
  url "https://ghfast.top/https://github.com/libvips/libvips/releases/download/v8.17.1/vips-8.17.1.tar.xz"
  sha256 "4d8c3325922c5300253d7594507a8f1d3caf8eed70dfb66cc7eb2cbed65bb5ca"
  license "LGPL-2.1-or-later"
  revision 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sequoia: "72b287e744af37353555933a373100c0d8c5cadf31d92c4377874dfd74cfafff"
    sha256 arm64_sonoma:  "8bb889dae35f3da145423798b33b4345dc2cb99213907f9b29ef7d724804c6b7"
    sha256 arm64_ventura: "299531d9933dfee35ec22798b5f46da9bdf8e84ec074ca44271fb8dc5fa590f2"
    sha256 sonoma:        "356171d33177624ee87a04a5768ba9099d5ac4b96b4a64676bc858b363c10f89"
    sha256 ventura:       "1a3212554928ab4ea674df5e4ccbea7301063224fb75151d424ef7aee1bd8a59"
    sha256 arm64_linux:   "400c78d054d9fbf7ad0326948e902996956ac1bcbc5ed6ba0f145acbf8da41cf"
    sha256 x86_64_linux:  "08ac0058f7bab1fe1451a3d721e7b559c70a38ffaeb73bb85bece9866c6640bc"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "cairo"
  depends_on "cfitsio"
  depends_on "cgif"
  depends_on "fftw"
  depends_on "fontconfig"
  depends_on "gettext"
  depends_on "glib"
  depends_on "highway"
  depends_on "imagemagick"
  depends_on "jpeg-xl"
  depends_on "libarchive"
  depends_on "libexif"
  depends_on "libheif"
  depends_on "libimagequant"
  depends_on "libmatio"
  depends_on "librsvg"
  depends_on "libspng"
  depends_on "libtiff"
  depends_on "little-cms2"
  depends_on "mozjpeg"
  depends_on "openexr"
  depends_on "openjpeg"
  depends_on "openslide"
  depends_on "pango"
  depends_on "poppler"
  depends_on "webp"

  uses_from_macos "python" => :build
  uses_from_macos "expat"
  uses_from_macos "zlib"

  def install
    # mozjpeg needs to appear before libjpeg, otherwise it's not used
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["mozjpeg"].opt_lib/"pkgconfig"

    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"

    if OS.mac?
      # `pkg-config --libs vips` includes libarchive, but that package is
      # keg-only so it needs to look for the pkgconfig file in libarchive's opt
      # path.
      libarchive = Formula["libarchive"].opt_prefix
      inreplace [lib/"pkgconfig/vips.pc", lib/"pkgconfig/vips-cpp.pc"] do |s|
        s.gsub!(/^Requires\.private:(.*)\blibarchive\b(.*?)(,.*)?$/,
                "Requires.private:\\1#{libarchive}/lib/pkgconfig/libarchive.pc\\3")
      end
    end
  end

  test do
    system bin/"vips", "-l"
    cmd = "#{bin}/vipsheader -f width #{test_fixtures("test.png")}"
    assert_equal "8", shell_output(cmd).chomp

    # --trellis-quant requires mozjpeg, vips warns if it's not present
    cmd = "#{bin}/vips jpegsave #{test_fixtures("test.png")} #{testpath}/test.jpg --trellis-quant 2>&1"
    assert_empty shell_output(cmd)

    # [palette] requires libimagequant, vips warns if it's not present
    cmd = "#{bin}/vips copy #{test_fixtures("test.png")} #{testpath}/test.png[palette] 2>&1"
    assert_empty shell_output(cmd)

    # Make sure `pkg-config` can parse `vips.pc` and `vips-cpp.pc` after the `inreplace`.
    system "pkgconf", "--print-errors", "vips"
    system "pkgconf", "--print-errors", "vips-cpp"
  end
end