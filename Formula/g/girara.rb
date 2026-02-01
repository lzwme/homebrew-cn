class Girara < Formula
  desc "GTK+3-based user interface library"
  homepage "https://pwmt.org/projects/girara/"
  url "https://pwmt.org/projects/girara/download/girara-2026.01.30.tar.xz"
  sha256 "41d93a2fbf708c2ee1b0e8e3933bf33d3bed0a11669a6832e23c988413b3b113"
  license "Zlib"

  livecheck do
    url "https://pwmt.org/projects/girara/download/"
    regex(/girara[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "78eae9047c4bc39c850ff0bcb08ec4c228be84865ff779a0437e1682ee2fe763"
    sha256 arm64_sequoia: "f0e9bb68e67a9ff733271d9103f8de0bc46730820ed34e2d21faccf66a2cabb3"
    sha256 arm64_sonoma:  "22b9f1e20f068be6a223f76fa74339aebd95338afc60e80c2d4206be18052f86"
    sha256 sonoma:        "491db29cb77b763e4b1724dd941afb2527b021a74223d60e8a3051c349099378"
    sha256 arm64_linux:   "34e14e9838a09ff6d4f7d0dea58f5ed80e18c8b4f470bb3dfb6d189811c20336"
    sha256 x86_64_linux:  "a9734fdd96abbd5aabe87ad763539707bb7ba0da2cc21a31af80cf1649b340d5"
  end

  depends_on "doxygen" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]

  depends_on "glib"
  depends_on "gtk+3"
  depends_on "pango"

  on_macos do
    depends_on "gettext"
  end

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
    (doc/"html").install Dir["build/doc/html/*"]
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include <stdlib.h>

      #include <girara/girara.h>

      int main(int argc, char** argv) {
        gtk_init(&argc, &argv);

        /* create girara session */
        girara_session_t* session = girara_session_create();

        if (session == NULL) {
          return -1;
        }

        if (girara_session_init(session, NULL) == false) {
          girara_session_destroy(session);
          return -1;
        }

        girara_session_destroy(session);

        return 0;
      }
    C
    pkg_config_flags = shell_output("pkg-config --cflags --libs girara-gtk3").chomp.split
    system ENV.cc, "test.c", *pkg_config_flags, "-o", "test"

    # Gtk-WARNING **: cannot open display
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system "./test"
  end
end