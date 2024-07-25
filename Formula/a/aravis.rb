class Aravis < Formula
  desc "Vision library for genicam based cameras"
  homepage "https:github.comAravisProjectaravis"
  url "https:github.comAravisProjectaravisreleasesdownload0.8.31aravis-0.8.31.tar.xz"
  sha256 "9c4ebe6273ed3abe466cb6ed8fa5c132bdd7e9a9298ca43fa0212c4311a084da"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_sonoma:   "92d2a832735db576610b78b26efa529f9ed0ae5e61f7d86588e5955f9e64a26d"
    sha256 arm64_ventura:  "c1bf4f1146b3658960e09736d3fb08cd640ecd597b89665d175e51b5a5bd3cd0"
    sha256 arm64_monterey: "2879866705ce34022653cf6838751e79b55c198dc7733ce19a75d41f48382aa9"
    sha256 sonoma:         "973c99a6806dac2ae3eb7447655e7108eb681033d3947557934892efd24e1ded"
    sha256 ventura:        "11d8e8bed23ea7cfd6cf8b72e2c54f3e85151b659d185468da508259753b20b1"
    sha256 monterey:       "63a17a0c9ab56dc2eb8b30d7a2fd99f3bf0eac141c2f5e17aa906db66567cb4c"
    sha256 x86_64_linux:   "d81bad462d46b7940211234830014a1c7b37f38cb09fe2792bd4e6a718282385"
  end

  depends_on "gobject-introspection" => :build
  depends_on "gtk-doc" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "adwaita-icon-theme"
  depends_on "glib"
  depends_on "gstreamer"
  depends_on "gtk+3"
  depends_on "intltool"
  depends_on "libnotify"
  depends_on "libusb"

  uses_from_macos "libxml2"
  uses_from_macos "zlib"

  on_macos do
    depends_on "at-spi2-core"
    depends_on "cairo"
    depends_on "gdk-pixbuf"
    depends_on "gettext"
    depends_on "harfbuzz"
    depends_on "pango"
  end

  def install
    ENV["XML_CATALOG_FILES"] = "#{etc}xmlcatalog"

    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  def post_install
    system "#{Formula["gtk+3"].opt_bin}gtk3-update-icon-cache", "-f", "-t", "#{HOMEBREW_PREFIX}shareiconshicolor"
  end

  def caveats
    <<~EOS
      For GStreamer to find the bundled plugin:
        export GST_PLUGIN_PATH=#{opt_lib}gstreamer-1.0
    EOS
  end

  test do
    lib_ext = OS.mac? ? "dylib" : "so"
    output = shell_output("gst-inspect-1.0 #{lib}gstreamer-1.0libgstaravis.#{version.major_minor}.#{lib_ext}")
    assert_match(Description *Aravis Video Source, output)
  end
end