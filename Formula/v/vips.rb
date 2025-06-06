class Vips < Formula
  desc "Image processing library"
  homepage "https:github.comlibvipslibvips"
  url "https:github.comlibvipslibvipsreleasesdownloadv8.17.0vips-8.17.0.tar.xz"
  sha256 "8256a82f2e64c119ffadac99822350f45212f16df2505ea8dbae5ff4d0001996"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sequoia: "75a042300766214876a2ad4e4c5bff8f4f02de9b4d9c0df17e4cb78c2c1f0ecd"
    sha256 arm64_sonoma:  "c2950df25501223403fd5f3341bf69465dbcdde25d5f42b2fbadd37c645405df"
    sha256 arm64_ventura: "3073eb27ae7f161671d31d289dd835ced33a69ba593e0864b4562a28ddefd867"
    sha256 sonoma:        "4090178bb6f094f468ba6f3051f959f4fcab9ec7fc508e148f94a8572442e0cc"
    sha256 ventura:       "5edb20f90efd58f788b49bde36ac409b77b8adfee067b08d713a80fa3097a22d"
    sha256 arm64_linux:   "7db5de862003792172fb03a517f5c8489d08c18c5a251506749e0c63c0e7ae2e"
    sha256 x86_64_linux:  "d8bef93b35cad09c8b8b70345b345c495bbf2479e155c81a1e546ee73995ccb5"
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
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["mozjpeg"].opt_lib"pkgconfig"

    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"

    if OS.mac?
      # `pkg-config --libs vips` includes libarchive, but that package is
      # keg-only so it needs to look for the pkgconfig file in libarchive's opt
      # path.
      libarchive = Formula["libarchive"].opt_prefix
      inreplace [lib"pkgconfigvips.pc", lib"pkgconfigvips-cpp.pc"] do |s|
        s.gsub!(^Requires\.private:(.*)\blibarchive\b(.*?)(,.*)?$,
                "Requires.private:\\1#{libarchive}libpkgconfiglibarchive.pc\\3")
      end
    end
  end

  test do
    system bin"vips", "-l"
    cmd = "#{bin}vipsheader -f width #{test_fixtures("test.png")}"
    assert_equal "8", shell_output(cmd).chomp

    # --trellis-quant requires mozjpeg, vips warns if it's not present
    cmd = "#{bin}vips jpegsave #{test_fixtures("test.png")} #{testpath}test.jpg --trellis-quant 2>&1"
    assert_empty shell_output(cmd)

    # [palette] requires libimagequant, vips warns if it's not present
    cmd = "#{bin}vips copy #{test_fixtures("test.png")} #{testpath}test.png[palette] 2>&1"
    assert_empty shell_output(cmd)

    # Make sure `pkg-config` can parse `vips.pc` and `vips-cpp.pc` after the `inreplace`.
    system "pkgconf", "--print-errors", "vips"
    system "pkgconf", "--print-errors", "vips-cpp"
  end
end