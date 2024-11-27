class Libsoup < Formula
  desc "HTTP client/server library for GNOME"
  homepage "https://wiki.gnome.org/Projects/libsoup"
  url "https://download.gnome.org/sources/libsoup/3.6/libsoup-3.6.1.tar.xz"
  sha256 "ceb1f1aa2bdd73b2cd8159d3998c96c55ef097ef15e4b4f36029209fa18af838"
  license "LGPL-2.0-or-later"

  bottle do
    sha256 arm64_sequoia: "59038c9b01838bd300de8378545f93ac519f5514fdbc46eb5d14f3c14fda283d"
    sha256 arm64_sonoma:  "0ca5b4869214fdbe8f94a95cadd4f54c76e90e7d654532e2dd47aead8e7115b1"
    sha256 arm64_ventura: "6e1ca00c8119f8822b07dd5f5afeb3a81b3826aa5996041690e83b41f0325eaa"
    sha256 sonoma:        "86f64098da67f9990514394e8628395adfec0a74047f95e64b3d72a6be5e3ddd"
    sha256 ventura:       "e10c4fd428919efd579e021ebfbffd5b99568456503bd8e4f4fd170924fc9dda"
    sha256 x86_64_linux:  "f104ffff26ffffbc3838c42fe3bdbff8be2f1b25f2e4570d2c30005dc24b3e48"
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