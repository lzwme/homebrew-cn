class Libsoup < Formula
  desc "HTTP client/server library for GNOME"
  homepage "https://wiki.gnome.org/Projects/libsoup"
  url "https://download.gnome.org/sources/libsoup/3.4/libsoup-3.4.4.tar.xz"
  sha256 "291c67725f36ed90ea43efff25064b69c5a2d1981488477c05c481a3b4b0c5aa"
  license "LGPL-2.0-or-later"

  bottle do
    sha256 arm64_sonoma:   "c4dc531ea8036eec8fd72a8113a9732c48463b648a1a386faceb347a12f35d95"
    sha256 arm64_ventura:  "518bf9d6ce898df5024f8c6b987b58ad71c8bcdeec285d9469fd12a561412441"
    sha256 arm64_monterey: "ed970d47202f2f621f1ee7565c6dfa82f7aeb25b492a6b133665cf2597baade7"
    sha256 sonoma:         "53f7084a45d065c75bbe1e0bc21695a6dd0cc743984adff14b70f2a639e10a96"
    sha256 ventura:        "e0b9b6e695e1772341d9d32c6a247e6c4cfa18bea3f1f6162ac4d3d6fb5cd2c8"
    sha256 monterey:       "57ce39074439c5a3e4a14661ae4012ebdde7692e745101d8f03db76f33852248"
    sha256 x86_64_linux:   "fec1b30444388241915ec32a660aa139d56084e5223abaaf123a884ccbf24e58"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.11" => :build
  depends_on "vala" => :build
  depends_on "glib-networking"
  depends_on "gnutls"
  depends_on "libpsl"

  uses_from_macos "krb5"
  uses_from_macos "libxml2"
  uses_from_macos "sqlite"

  on_linux do
    depends_on "brotli"
  end

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    # if this test start failing, the problem might very well be in glib-networking instead of libsoup
    (testpath/"test.c").write <<~EOS
      #include <libsoup/soup.h>

      int main(int argc, char *argv[]) {
        SoupMessage *msg = soup_message_new(SOUP_METHOD_GET, "https://brew.sh");
        SoupSession *session = soup_session_new();
        GError *error = NULL;
        GBytes *bytes = soup_session_send_and_read(session, msg, NULL, &error); // blocks

        if(error) {
          g_error_free(error);
          return 1;
        }

        g_object_unref(msg);
        g_object_unref(session);
        return 0;
      }
    EOS
    ENV.libxml2
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    flags = %W[
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{include}/libsoup-3.0
      -D_REENTRANT
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{lib}
      -lgio-2.0
      -lglib-2.0
      -lgobject-2.0
      -lsoup-3.0
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end