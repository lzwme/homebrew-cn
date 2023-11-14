class Gexiv2 < Formula
  desc "GObject wrapper around the Exiv2 photo metadata library"
  homepage "https://wiki.gnome.org/Projects/gexiv2"
  # release info on the website might lag behind, refer to gitlab tags for latest release info
  # see discussions in https://gitlab.gnome.org/GNOME/gexiv2/-/issues/77
  url "https://download.gnome.org/sources/gexiv2/0.14/gexiv2-0.14.2.tar.xz"
  sha256 "2a0c9cf48fbe8b3435008866ffd40b8eddb0667d2212b42396fdf688e93ce0be"
  license "GPL-2.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "946792d04c7db89b11192f4d3cf5cd0d18ccfb6a9e4911ed48d89198bf0bdfd3"
    sha256 cellar: :any, arm64_ventura:  "e2341c3fefd5644a3c8f636fcd69d1defde69bb2bd93213622c04444499d24f7"
    sha256 cellar: :any, arm64_monterey: "4b181df721ec247288cae8797e8a2ec67c59d28d8c29d4cbe1ce27f129df8489"
    sha256 cellar: :any, sonoma:         "db64e4074fbca3d8e33fed25f0133f74bc610a3e069df77e78fe706117c3c489"
    sha256 cellar: :any, ventura:        "48ac72a299229652ed8c62c1b38eac0f291f1e1a7df0825a8d25e59f2a9a0317"
    sha256 cellar: :any, monterey:       "3896495b29c74c5e4a10198cab6491861f37758fc8691ccfc08ea7c20b7c7f2a"
    sha256               x86_64_linux:   "b17f76ea6f1c459d28abb2b0738541eb2cc1ce386d445cb277538fe3c498afe1"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "pygobject3" => :build
  depends_on "python@3.11" => :build
  depends_on "vala" => :build
  depends_on "exiv2"
  depends_on "glib"

  def install
    # Update to use c++17 when `exiv2` is updated to use c++17
    system "meson", *std_meson_args, "build", "-Dcpp_std=c++11"
    system "meson", "compile", "-C", "build", "-v"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <gexiv2/gexiv2.h>
      int main() {
        GExiv2Metadata *metadata = gexiv2_metadata_new();
        return 0;
      }
    EOS

    system ENV.cc, "test.c", "-o", "test",
                   "-I#{HOMEBREW_PREFIX}/include/glib-2.0",
                   "-I#{HOMEBREW_PREFIX}/lib/glib-2.0/include",
                   "-L#{lib}",
                   "-lgexiv2"
    system "./test"
  end
end