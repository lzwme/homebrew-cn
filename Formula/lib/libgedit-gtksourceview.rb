class LibgeditGtksourceview < Formula
  desc "Text editor widget for code editing"
  homepage "https:gedit-technology.net"
  url "https:gedit-technology.nettarballslibgedit-gtksourceviewlibgedit-gtksourceview-299.0.4.tar.xz"
  sha256 "7453a1cce2f6d58871644d2203ecdbbb043050886170ebea376c1cf6e27f86d8"
  license "LGPL-2.1-only"
  revision 1
  head "https:github.comgedit-technologylibgedit-gtksourceview.git", branch: "main"

  bottle do
    sha256 arm64_sonoma:   "a8e3b2020589892dc86ed28f6f7eac7f3b919425afc540308f6eef107c347804"
    sha256 arm64_ventura:  "0eb74462ae1ca6d0186b59d697dbf575a3993182cebc4abe6bc058464893f7dd"
    sha256 arm64_monterey: "270294063c104f7a9e6ad0a48a57f2f99ecd545ba8fa95f552ba12640412f639"
    sha256 sonoma:         "3afd8184043d8168639aca39f777267f3f3152b13d3ffc705b9d24dbeedd66e7"
    sha256 ventura:        "77d01231fce8196d52aa4d3394f2ed1780d5808502e78a682e7c0ec2d6ed1f30"
    sha256 monterey:       "7b2b1a817c1d69673398f44cce5ecc86a764ee4c7c820f6fb1609b100674c500"
    sha256 x86_64_linux:   "ed1218ce73ff70c1e1c5923a9509e3df6ddfa9a87f7c9c2e1e06728059d2b73a"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "gtk+3"
  depends_on "libxml2" # Dependent `gedit` uses Homebrew `libxml2`

  def install
    system "meson", "setup", "build", *std_meson_args, "-Dgtk_doc=false"
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath"test.c").write <<~EOS
      #include <gtksourceviewgtksource.h>

      int main(int argc, char *argv[]) {
        gchar *text = gtk_source_utils_unescape_search_text("hello world");
        return 0;
      }
    EOS
    flags = shell_output("pkg-config --cflags --libs libgedit-gtksourceview-300").strip.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system ".test"
  end
end