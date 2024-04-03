class GobjectIntrospection < Formula
  include Language::Python::Shebang
  include Language::Python::Virtualenv

  desc "Generate introspection data for GObject libraries"
  homepage "https:gi.readthedocs.ioenlatest"
  url "https:download.gnome.orgsourcesgobject-introspection1.80gobject-introspection-1.80.1.tar.xz"
  sha256 "a1df7c424e15bda1ab639c00e9051b9adf5cea1a9e512f8a603b53cd199bc6d8"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.0-or-later", "MIT"]

  bottle do
    sha256 arm64_sonoma:   "c1c697721fa887da0a7ecf1da74166307dda223b8cd922480d35ee7528455a79"
    sha256 arm64_ventura:  "0c84786d152faae9223090e6fdd185bf233c556a4ead8d14fc0854d276d7fa88"
    sha256 arm64_monterey: "af672a045ca17ed75abf4599981ca482df1dd2a28eb28962ac55ed129e906805"
    sha256 sonoma:         "46ed11128af5bdb834a7f216fa222854fd274cab9314105b2ff73359254df56d"
    sha256 ventura:        "03e5c450af9264cfe141056ccd91a5866eab01f3a15f22269092a0482a335eae"
    sha256 monterey:       "965341cb99b3ce445576e7e74ec23e974a3366b8e1b5a6ae708810e10e550e4f"
    sha256 x86_64_linux:   "57923660703711398295e51f51d1f4d976ce0220b2d116bba14c240ece504925"
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "cairo"
  depends_on "glib"
  depends_on "pkg-config"
  # Ships a `_giscanner.cpython-312-darwin.so`, so needs a specific version.
  depends_on "python@3.12"

  uses_from_macos "flex" => :build
  uses_from_macos "libffi", since: :catalina

  resource "mako" do
    url "https:files.pythonhosted.orgpackagesd41b71434d9fa9be1ac1bc6fb5f54b9d41233be2969f16be759766208f49f072Mako-1.3.2.tar.gz"
    sha256 "2a0c8ad7f6274271b3bb7467dd37cf9cc6dab4bc19cb69a4ef10669402de698e"
  end

  resource "markdown" do
    url "https:files.pythonhosted.orgpackages22024785861427848cc11e452cc62bb541006a1087cf04a1de83aedd5530b948Markdown-3.6.tar.gz"
    sha256 "ed4f41f6daecbeeb96e576ce414c41d2d876daa9a16cb35fa8ed8c2ddfad0224"
  end

  resource "markupsafe" do
    url "https:files.pythonhosted.orgpackages875baae44c6655f3801e81aa3eef09dbbf012431987ba564d7231722f68df02dMarkupSafe-2.1.5.tar.gz"
    sha256 "d283d37a890ba4c1ae73ffadf8046435c76e7bc2247bbb63c00bd1a709c6544b"
  end

  resource "setuptools" do
    url "https:files.pythonhosted.orgpackages4d5bdc575711b6b8f2f866131a40d053e30e962e633b332acf7cd2c24843d83dsetuptools-69.2.0.tar.gz"
    sha256 "0ff4183f8f42cd8fa3acea16c45205521a4ef28f73c6391d8a25e92893134f2e"
  end

  # Fix library search path on non-usrlocal installs (e.g. Apple Silicon)
  # See: https:github.comHomebrewhomebrew-coreissues75020
  #      https:gitlab.gnome.orgGNOMEgobject-introspection-merge_requests273
  patch do
    url "https:gitlab.gnome.orgtschoonjgobject-introspection-commita7be304478b25271166cd92d110f251a8742d16b.diff"
    sha256 "740c9fba499b1491689b0b1216f9e693e5cb35c9a8565df4314341122ce12f81"
  end

  def install
    venv = virtualenv_create(libexec, "python3.12")
    venv.pip_install resources
    ENV.prepend_path "PATH", venv.root"bin"

    ENV["GI_SCANNER_DISABLE_CACHE"] = "true"

    inreplace "giscannertransformer.py", "usrshare", "#{HOMEBREW_PREFIX}share"
    inreplace "meson.build",
      "config.set_quoted('GOBJECT_INTROSPECTION_LIBDIR', join_paths(get_option('prefix'), get_option('libdir')))",
      "config.set_quoted('GOBJECT_INTROSPECTION_LIBDIR', '#{HOMEBREW_PREFIX}lib')"

    system "meson", "setup", "build", "-Dpython=#{venv.root}binpython",
                                      "-Dextra_library_paths=#{HOMEBREW_PREFIX}lib",
                                      *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"

    rewrite_shebang python_shebang_rewrite_info(venv.root"binpython"), *bin.children
  end

  test do
    (testpath"main.c").write <<~EOS
      #include <girepository.h>

      int main (int argc, char *argv[]) {
        GIRepository *repo = g_irepository_get_default();
        g_assert_nonnull(repo);
        return 0;
      }
    EOS

    pkg_config_flags = shell_output("pkg-config --cflags --libs gobject-introspection-1.0").strip.split
    system ENV.cc, "main.c", "-o", "test", *pkg_config_flags
    system ".test"
  end
end