class LibgeditTepl < Formula
  desc "Gedit Technology - Text editor product line"
  homepage "https:gitlab.gnome.orgWorldgeditlibgedit-tepl"
  url "https:gitlab.gnome.orgWorldgeditlibgedit-tepl-archive6.10.0libgedit-tepl-6.10.0.tar.bz2"
  sha256 "bfaf68a4c81b7e32ff69d102dad1d656c49b5ef8570db15327a3c5479c8c3164"
  license "LGPL-2.1-or-later"
  revision 2
  head "https:gitlab.gnome.orgWorldgeditlibgedit-tepl.git", branch: "main"

  # https:gitlab.gnome.orgswilmettepl-blobmaindocsmore-information.md
  # Tepl follows the evenodd minor version scheme. Odd minor versions are
  # development snapshots; even minor versions are stable.
  livecheck do
    url :stable
    regex(^v?(\d+\.\d*[02468](?:\.\d+)*)$i)
  end

  bottle do
    sha256 arm64_sequoia: "4f5e58d214ebaf7a8e48f5688532da1c3165808f120db8b37ed6615bb84a2c86"
    sha256 arm64_sonoma:  "c2128dc28a61fc7f4199a37308015fd6cd809ef6098b589c709ce81d9760e22c"
    sha256 arm64_ventura: "c0d45ab2b18d1dc253e01fb168a7121b97d8bcd1e16aa513c797313ab4c621c3"
    sha256 sonoma:        "cba802dbc0bb7e182c2d2f4346ef485088cc745c00a786d2020194f10b833958"
    sha256 ventura:       "0ab303812624e1565d97a29f6e6ef350d370efdff1027cafac1ad1c08f68bdcf"
    sha256 x86_64_linux:  "d4af145b90a3a9082188c83ac10dd0bd62f846140ba60a36bb9a98ff8b1057b8"
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