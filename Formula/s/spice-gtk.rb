class SpiceGtk < Formula
  include Language::Python::Virtualenv

  desc "GTK client/libraries for SPICE"
  homepage "https://www.spice-space.org"
  url "https://www.spice-space.org/download/gtk/spice-gtk-0.42.tar.xz"
  sha256 "9380117f1811ad1faa1812cb6602479b6290d4a0d8cc442d44427f7f6c0e7a58"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later", "BSD-3-Clause"]
  revision 2

  livecheck do
    url "https://www.spice-space.org/download/gtk/"
    regex(/href=.*?spice-gtk[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_ventura:  "72e82feb3a6e163e87202dfec50f6e434519cdd080511fe6d50179c3f913c36b"
    sha256 arm64_monterey: "7405f31550ec07d48ec970158f3b5498d4d8b940bcfcf930a078c681f13b5383"
    sha256 ventura:        "7a98d59c135af9d0512ef1da66d03ae1017bef61442ced1b22aeb8851025e477"
    sha256 monterey:       "c7f1f4442a9ede6b40507db3195b1fa1eb5720e3dfca7ef9522e5cb32db69048"
    sha256 x86_64_linux:   "13080eae5ee1a111247b04dacde796c2a63e02a3104800c55cd26fc31675aa42"
  end

  depends_on "gobject-introspection" => :build
  depends_on "intltool" => :build
  depends_on "libtool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.12" => :build
  depends_on "six" => :build
  depends_on "vala" => :build

  depends_on "atk"
  depends_on "cairo"
  depends_on "gdk-pixbuf"
  depends_on "gettext"
  depends_on "glib"
  depends_on "gstreamer"
  depends_on "gtk+3"
  depends_on "jpeg-turbo"
  depends_on "json-glib"
  depends_on "libusb"
  depends_on "lz4"
  depends_on "openssl@3"
  depends_on "opus"
  depends_on "pango"
  depends_on "pixman"
  depends_on "python-pyparsing"
  depends_on "spice-protocol"
  depends_on "usbredir"

  # https://gitlab.com/keycodemap/keycodemapdb/-/merge_requests/18
  patch :DATA

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <spice-client.h>
      #include <spice-client-gtk.h>
      int main() {
        return spice_session_new() ? 0 : 1;
      }
    EOS
    system ENV.cc, "test.cpp",
                   "-I#{Formula["atk"].include}/atk-1.0",
                   "-I#{Formula["cairo"].include}/cairo",
                   "-I#{Formula["gdk-pixbuf"].include}/gdk-pixbuf-2.0",
                   "-I#{Formula["glib"].include}/glib-2.0",
                   "-I#{Formula["glib"].lib}/glib-2.0/include",
                   "-I#{Formula["gtk+3"].include}/gtk-3.0",
                   "-I#{Formula["harfbuzz"].opt_include}/harfbuzz",
                   "-I#{Formula["pango"].include}/pango-1.0",
                   "-I#{Formula["spice-protocol"].include}/spice-1",
                   "-I#{include}/spice-client-glib-2.0",
                   "-I#{include}/spice-client-gtk-3.0",
                   "-L#{lib}",
                   "-lspice-client-glib-2.0",
                   "-lspice-client-gtk-3.0",
                   "-o", "test"
    system "./test"
  end
end
__END__
diff --git a/subprojects/keycodemapdb/tools/keymap-gen b/subprojects/keycodemapdb/tools/keymap-gen
index b6cc95b..d05e945 100755
--- a/subprojects/keycodemapdb/tools/keymap-gen
+++ b/subprojects/keycodemapdb/tools/keymap-gen
@@ -1,4 +1,4 @@
-#!/usr/bin/python3
+#!/usr/bin/env python3
 # -*- python -*-
 #
 # Keycode Map Generator