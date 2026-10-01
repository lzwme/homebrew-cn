class Libsoup < Formula
  desc "HTTP client/server library for GNOME"
  homepage "https://wiki.gnome.org/Projects/libsoup"
  url "https://download.gnome.org/sources/libsoup/3.8/libsoup-3.8.0.tar.xz"
  sha256 "bbf08fa3e03a88c31a3d27a0d87cb422e9490f2d08e149211103df6d638a2238"
  license "LGPL-2.0-or-later"
  compatibility_version 1

  bottle do
    sha256               arm64_golden_gate: "a1fbb62038cdd7bc55ce07ae592eeb0df01520e37a211c95aeb0fd5d82c98415"
    sha256               arm64_tahoe:       "3d0e6032d46f74fa113ff206c1d5c54540e8cc18c39c825c4545e2955a75db0c"
    sha256               arm64_sequoia:     "a8f0e6cbcbedc43bcecc98815f2abcc764bd4d7f33f9c574c4dbfe882c079160"
    sha256 cellar: :any, arm64_linux:       "815c66094a8ab73fb8ba1a60c9ea1a192c027a480d4889d7410ae1a90e8599a8"
    sha256 cellar: :any, x86_64_linux:      "657404066287b2d6dc7dc6ed0ecd56f7d1e82a6ad7a16fcfe3cfcac7f3d5b508"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "vala" => :build

  depends_on "glib"
  depends_on "glib-networking" => :no_linkage
  depends_on "libnghttp2"
  depends_on "libpsl"
  depends_on "sqlite"
  depends_on "zstd"

  uses_from_macos "python" => :build
  uses_from_macos "krb5"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "brotli"
    depends_on "zlib-ng-compat"
  end

  allow_network_access! :test

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