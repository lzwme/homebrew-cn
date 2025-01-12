class Libsoup < Formula
  desc "HTTP client/server library for GNOME"
  homepage "https://wiki.gnome.org/Projects/libsoup"
  url "https://download.gnome.org/sources/libsoup/3.6/libsoup-3.6.3.tar.xz"
  sha256 "a0d84ab07bd168b317d319b0dc40c8b301b4543fba2ec42fa733914b2081afbd"
  license "LGPL-2.0-or-later"

  bottle do
    sha256 arm64_sequoia: "8ea0a75139911db1479f6532d02b8164262a7abec64f3afef08eb15633bfedae"
    sha256 arm64_sonoma:  "bcd716ae7b071110c49ea594388e029a8961e4e9aaae11cee8059bbbbb84376f"
    sha256 arm64_ventura: "4bf424dc4f8ccae8736d88c98b94404fce2b4d9d806a2de11364e68d16895f05"
    sha256 sonoma:        "0599b0422068ecae104b556054a7fdaadf007eab0b9ebd2d8f94045e2300feea"
    sha256 ventura:       "8558478d19c58ee316f59469fc48958412b38ba682cffb74ed5d940297fdd649"
    sha256 x86_64_linux:  "8183d36dee6b03b7ca41362ed1e1ad226da7e34ee446d964dc55bb6d7ec38b71"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "python@3.12" => :build
  depends_on "vala" => :build

  depends_on "glib"
  depends_on "glib-networking"
  depends_on "gnutls"
  depends_on "libnghttp2"
  depends_on "libpsl"
  depends_on "sqlite"

  uses_from_macos "krb5"
  uses_from_macos "libxml2"
  uses_from_macos "zlib"

  on_macos do
    depends_on "gettext"
  end

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
    (testpath/"test.c").write <<~C
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
    C

    flags = shell_output("pkgconf --cflags --libs libsoup-3.0").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end