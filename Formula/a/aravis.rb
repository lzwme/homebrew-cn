class Aravis < Formula
  desc "Vision library for genicam based cameras"
  homepage "https://wiki.gnome.org/Projects/Aravis"
  url "https://ghproxy.com/https://github.com/AravisProject/aravis/releases/download/0.8.30/aravis-0.8.30.tar.xz"
  sha256 "40380f06fa04524a7875bd456e5a5ea78b2c058fa84b5598bc6e0642fcef00b0"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_sonoma:   "56b62cc4c88b0eaa1ee1681b7c6a8e8d19f3adaefd254d7b1f736e897e45dc84"
    sha256 arm64_ventura:  "a1d44f5d913fd1ebb81778e4e221957c0ffc66a56c4027a10a7a3d5bcdc53cc6"
    sha256 arm64_monterey: "6ac787f82f282a1694683b8d00e5f1a1a7c4287208e433a9fe83b40d2f0c209c"
    sha256 sonoma:         "474f3f6d81ace01753742d4998b214ee38b997e3e04c8d4ceb8d33370ceeb7fd"
    sha256 ventura:        "4ae57e8e2f9ff565eb469a942d6df73f544786263a696bfa7e6454c261515164"
    sha256 monterey:       "b4eb54eb6a099375f9c9b0d7060771dbaea113ddc982be2e010e1ccfa52b98f1"
    sha256 x86_64_linux:   "72e0788362c00f7f18b6dfb42247f8d53080e0be76dd34269825551d86e63066"
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

  def install
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"

    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  def post_install
    system "#{Formula["gtk+3"].opt_bin}/gtk3-update-icon-cache", "-f", "-t", "#{HOMEBREW_PREFIX}/share/icons/hicolor"
  end

  def caveats
    <<~EOS
      For GStreamer to find the bundled plugin:
        export GST_PLUGIN_PATH=#{opt_lib}/gstreamer-1.0
    EOS
  end

  test do
    lib_ext = OS.mac? ? "dylib" : "so"
    output = shell_output("gst-inspect-1.0 #{lib}/gstreamer-1.0/libgstaravis.#{version.major_minor}.#{lib_ext}")
    assert_match(/Description *Aravis Video Source/, output)
  end
end