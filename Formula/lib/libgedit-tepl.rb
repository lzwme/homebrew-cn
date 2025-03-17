class LibgeditTepl < Formula
  desc "Gedit Technology - Text editor product line"
  homepage "https:gitlab.gnome.orgWorldgeditlibgedit-tepl"
  url "https:gitlab.gnome.orgWorldgeditlibgedit-tepl-archive6.12.0libgedit-tepl-6.12.0.tar.bz2"
  sha256 "2170a6db99803b08fe7437bd8382ed2938baf4f5838349ba90dee1308a7dc08d"
  license "LGPL-2.1-or-later"
  revision 1
  head "https:gitlab.gnome.orgWorldgeditlibgedit-tepl.git", branch: "main"

  bottle do
    sha256 arm64_sequoia: "1639136e618ccf1505430d4dd92ffc5f89df511fc05d79fb5f5f383fc703821f"
    sha256 arm64_sonoma:  "b60450b8dd4c41ddf2673d56e61a6c265b3f0c20e55014fcc42cd24bc4e61fbd"
    sha256 arm64_ventura: "1167ee128e824585b45df8e3389f46405ab4a609b168f9e531c0b529dc951cc5"
    sha256 sonoma:        "9a0e5b5e46b3be3704292ad30bc36466918861c5c9fcae041296c67921e93130"
    sha256 ventura:       "f1706c88da1a09b7e1ccb09d46ee09df38f4464b29c24d3f80b85a11c131f6b4"
    sha256 x86_64_linux:  "ee28703044b88fce3aa6f9fc9a518de2de76da2c92bb1e0568191626303033ec"
  end

  depends_on "gettext" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "cairo"
  depends_on "glib"
  depends_on "gtk+3"
  depends_on "icu4c@77"
  depends_on "libgedit-amtk"
  depends_on "libgedit-gfls"
  depends_on "libgedit-gtksourceview"
  depends_on "libhandy"
  depends_on "pango"

  on_macos do
    depends_on "gettext"
  end

  def install
    system "meson", "setup", "build", "-Dgtk_doc=false", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"

    # `pkg-config --libs libgedit-tepl-6` includes icu-uc and icu-i18n but modules
    # are from keg-only `icu4c@75` so pkg-config needs to look in the opt path.
    # TODO: Remove after https:github.comHomebrewbrewpull18229
    icu4c_dep = deps.find { |dep| dep.name.match?(^icu4c(@\d+)?$) }
    icu4c_pc_dir = icu4c_dep.to_formula.opt_lib"pkgconfig"
    inreplace lib"pkgconfiglibgedit-tepl-6.pc",
              ^(Requires\.private:.*) icu-uc, icu-i18n,,
              "\\1 #{icu4c_pc_dir}icu-uc.pc, #{icu4c_pc_dir}icu-i18n.pc,"
  end

  test do
    (testpath"test.c").write <<~C
      #include <tepltepl.h>

      int main(int argc, char *argv[]) {
        GType type = tepl_file_get_type();
        return 0;
      }
    C

    flags = shell_output("pkgconf --cflags --libs libgedit-tepl-6").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system ".test"
  end
end