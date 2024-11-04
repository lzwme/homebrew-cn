class LibgeditTepl < Formula
  desc "Gedit Technology - Text editor product line"
  homepage "https:gitlab.gnome.orgWorldgeditlibgedit-tepl"
  url "https:gitlab.gnome.orgWorldgeditlibgedit-tepl-archive6.11.0libgedit-tepl-6.11.0.tar.bz2"
  sha256 "3b46bae85ae59adbfa63570a6e3818ce27643f1c36e7a8ea866bc141d74727fd"
  license "LGPL-2.1-or-later"
  head "https:gitlab.gnome.orgWorldgeditlibgedit-tepl.git", branch: "main"

  bottle do
    sha256 arm64_sequoia: "0d2578e0d31bbfae6655aaaceef057d1589406206fa7cc079a0e026a9a7248e0"
    sha256 arm64_sonoma:  "ac5d34deeeb878f76f45e1446c7f88aaabcd965c111e9d48192f14598cb7659a"
    sha256 arm64_ventura: "34ad76b173ef89688270bfae41e7818765690ef4f64361205c7b24c60fd42289"
    sha256 sonoma:        "39ca15d71c3477a28ed02cbed40307e8739d472fd0ddc370d98a1a61ed7efedc"
    sha256 ventura:       "9e158eb01c337a3d3640f095cf2c383bdf7e223c92942e3de9a81645f7082c1e"
    sha256 x86_64_linux:  "f6e1d3a6e8b52f2cf3712173ad9a0ef8359a754698e4b762a388af22aaa326d8"
  end

  depends_on "gettext" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "cairo"
  depends_on "glib"
  depends_on "gtk+3"
  depends_on "icu4c@76"
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

    flags = shell_output("pkg-config --cflags --libs libgedit-tepl-6").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system ".test"
  end
end