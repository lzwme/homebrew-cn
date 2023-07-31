class Aravis < Formula
  desc "Vision library for genicam based cameras"
  homepage "https://wiki.gnome.org/Projects/Aravis"
  url "https://ghproxy.com/https://github.com/AravisProject/aravis/releases/download/0.8.28/aravis-0.8.28.tar.xz"
  sha256 "c350e25b84a57c0bc09aa9bf931d64ea8469201ed3ffd4cf02ac49dc98a3eedf"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_ventura:  "3a1cc67466a72fd2286077db588f6d3852bced5ded51dab874b03891ce101768"
    sha256 arm64_monterey: "bff05f2d53b4d45e39fd515a2346e7c837c8a0c743912a21273204b98c1d0d9d"
    sha256 arm64_big_sur:  "3228a44e03b7b67cf0c465bafc8443a424a110e856d830371fa5247de1d68c9d"
    sha256 ventura:        "e0ee70f15e72b592b8147db3b90829f5d24493e2713fb5cf1d819819a42d2ae8"
    sha256 monterey:       "90270918af89c6a9b36a2f1ec1f00280909d888d8011db24aa91ecf7f65d9d7c"
    sha256 big_sur:        "d1d30c244a23e38f5c9748151036998ddc32d0d67c5d85ade1e16b93ea5f82af"
    sha256 x86_64_linux:   "01c48ba983015e9b8d454bb4fd662bb61478244070ea89f74f27a17aaa3bcf9a"
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