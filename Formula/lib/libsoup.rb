class Libsoup < Formula
  desc "HTTP client/server library for GNOME"
  homepage "https://wiki.gnome.org/Projects/libsoup"
  url "https://download.gnome.org/sources/libsoup/3.6/libsoup-3.6.6.tar.xz"
  sha256 "51ed0ae06f9d5a40f401ff459e2e5f652f9a510b7730e1359ee66d14d4872740"
  license "LGPL-2.0-or-later"

  bottle do
    sha256 arm64_tahoe:   "b71db2963a02429ef71c1e7d91849e787647f3618588240c62b219a5c8e9ed95"
    sha256 arm64_sequoia: "8ce0cc1e7c7499e6a3f501917bd58fb68d00191ff1250d2ca6656f8621cfe7a5"
    sha256 arm64_sonoma:  "59abd290b9d92f7aba4640530b1bc13d603b3ab83f2cb68bc1812ec00e9cc9a1"
    sha256 sonoma:        "20c710eb88ac34adabede5b55e93a8f5a7d706281b0a2746d598595669027676"
    sha256 arm64_linux:   "85fe541a49747400205b335bb72ed043d4a73974918747d6cb284105dc92e722"
    sha256 x86_64_linux:  "ed610815d572c29515dc439816a6ef83c4982ea9653cd0beb131fa70ef2db90f"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "vala" => :build

  depends_on "glib"
  depends_on "glib-networking" => :no_linkage
  depends_on "gnutls"
  depends_on "libnghttp2"
  depends_on "libpsl"
  depends_on "sqlite"

  uses_from_macos "python" => :build
  uses_from_macos "krb5"
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