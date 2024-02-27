class Libspelling < Formula
  desc "Spellcheck library for GTK 4"
  homepage "https://gitlab.gnome.org/chergert/libspelling"
  url "https://gitlab.gnome.org/chergert/libspelling/-/archive/0.2.0/libspelling-0.2.0.tar.bz2"
  sha256 "5ec7852d8e27f0dad3b1b6fcb49b1fe5d33aa74cc12d6366e2f84efec05e925c"
  license "LGPL-2.1-or-later"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "1f97b60ee070b3bd1e297c1edd97474051457ce9fdb073539f514bdb553cbf95"
    sha256 cellar: :any, arm64_ventura:  "9caeff69d490d3e0c9d85f9e97f66a718a169c01ad955bc12d0b2202fcfd39e7"
    sha256 cellar: :any, arm64_monterey: "f3fdde20ffa11fc44b49e5704ccbc8344a46c1153f0b0f72071cad455b5dbe79"
    sha256 cellar: :any, sonoma:         "b4f1639d70de8fa41444cd95941b4ce4aea9e225d3077af71df91727121cc6b1"
    sha256 cellar: :any, ventura:        "dadd6f3fe628c2f4455cb2f09f41c1d9d6671db3390815cb66de913caa912776"
    sha256 cellar: :any, monterey:       "e014e53690dedec4c14724db6d45ced43357ed138f6ed9ba915e8f57c901a396"
    sha256               x86_64_linux:   "b6e3c0931ca384e7cdb24955cbd137eb1e2101fba59ff3c602509dc205795db7"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "vala" => :build
  depends_on "enchant"
  depends_on "glib"
  depends_on "gtk4"
  depends_on "gtksourceview5"

  def install
    system "meson", "setup", "build", "-Ddocs=false", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <libspelling.h>

      int main(int argc, char *argv[]) {
        SpellingChecker *checker = spelling_checker_get_default();
        return 0;
      }
    EOS

    pkg_config_cflags = shell_output("pkg-config --cflags --libs libspelling-1").chomp.split
    system ENV.cc, "test.c", *pkg_config_cflags, "-o", "test"
    system "./test"
  end
end