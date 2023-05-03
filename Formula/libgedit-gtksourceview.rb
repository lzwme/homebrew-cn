class LibgeditGtksourceview < Formula
  desc "Text editor widget for code editing"
  homepage "https://gedit-technology.net"
  url "https://gedit-technology.net/tarballs/libgedit-gtksourceview/libgedit-gtksourceview-299.0.1.tar.xz"
  sha256 "74f8521b70a357708b08e2fdab28fb7796e0b67f6f8a7926a753b61cf3e9960b"
  license "LGPL-2.1-only"
  head "https://github.com/gedit-technology/libgedit-gtksourceview.git", branch: "main"

  bottle do
    sha256 arm64_ventura:  "f05db7f2b4032c88cbb33a98599acb5fadc049cdbbacd1c1acce423205dfda25"
    sha256 arm64_monterey: "9e11e41ebcc100c6f335e10dd456abf1267eace560dbda3aa7fdd5923e20732f"
    sha256 arm64_big_sur:  "e93b9e6518016a2d9fb40e15ae42103ca2fcdff0f89e795ba53f747b0f146149"
    sha256 ventura:        "1c24a3aef344f51aa73bcdd51110fa159dd30cd7075c11611153141ce7fa530f"
    sha256 monterey:       "e9988e7a293d67aac67da86bac5637620961ed3507cf4661b589e59902d0b93e"
    sha256 big_sur:        "60d7d6f05c9e1771628abbbc53dae5c6c1063c98a769577cfe6c03306be71cb4"
    sha256 x86_64_linux:   "e718b1e0b9e2bf33f93f5e06c617c63385db9cf78879382d8fa79f9093707ca7"
  end

  depends_on "gobject-introspection" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "gtk+3"
  depends_on "libxml2" # Dependent `gedit` uses Homebrew `libxml2`

  def install
    system "./configure", *std_configure_args, "--disable-silent-rules", "--enable-introspection"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <gtksourceview/gtksource.h>

      int main(int argc, char *argv[]) {
        gchar *text = gtk_source_utils_unescape_search_text("hello world");
        return 0;
      }
    EOS
    flags = shell_output("pkg-config --cflags --libs libgedit-gtksourceview-300").strip.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end