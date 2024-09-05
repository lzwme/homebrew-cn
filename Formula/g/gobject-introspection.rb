class GobjectIntrospection < Formula
  include Language::Python::Shebang
  include Language::Python::Virtualenv

  desc "Generate introspection data for GObject libraries"
  homepage "https:gi.readthedocs.ioenlatest"
  url "https:download.gnome.orgsourcesgobject-introspection1.80gobject-introspection-1.80.1.tar.xz"
  sha256 "a1df7c424e15bda1ab639c00e9051b9adf5cea1a9e512f8a603b53cd199bc6d8"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.0-or-later", "MIT"]
  revision 1

  bottle do
    sha256 arm64_sonoma:   "e28f50144066ecbc4215381aa26c238e8dac6ca0362b1e603784ff48dc6e5e7a"
    sha256 arm64_ventura:  "f89a382a4431e4c45ecb3de881344e6c5cd1a4a3d5ba5e589bffbc6af4015478"
    sha256 arm64_monterey: "e86c150176699e055c782a3ce9ae54ca7f11aa2f49cb513ea034ea8548a38daf"
    sha256 sonoma:         "2ae0d61dd15cefe025aa2d2fcff53f59922ee4617de110dd53890b83a0c7fe87"
    sha256 ventura:        "778bbc5bdd75e7d532116dc6db6a3e65ed7ce6382d93c9478e7f63f1635f77be"
    sha256 monterey:       "93689c0323a853f42ba85ffab5856267b11b88d497b53faaffc60e6411f105a2"
    sha256 x86_64_linux:   "a45a7a0410ff701fd481e4c9ae57920cb19b9676f357c956dd72e6e60b95dd29"
  end

  depends_on "bison" => :build
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
    url "https:files.pythonhosted.orgpackages6703fb5ba97ff65ce64f6d35b582aacffc26b693a98053fa831ab43a437cbddbMako-1.3.5.tar.gz"
    sha256 "48dbc20568c1d276a2698b36d968fa76161bf127194907ea6fc594fa81f943bc"
  end

  resource "markdown" do
    url "https:files.pythonhosted.orgpackages54283af612670f82f4c056911fbbbb42760255801b3068c48de792d354ff4472markdown-3.7.tar.gz"
    sha256 "2ae2471477cfd02dbbf038d5d9bc226d40def84b4fe2986e49b59b6b472bbed2"
  end

  resource "markupsafe" do
    url "https:files.pythonhosted.orgpackages875baae44c6655f3801e81aa3eef09dbbf012431987ba564d7231722f68df02dMarkupSafe-2.1.5.tar.gz"
    sha256 "d283d37a890ba4c1ae73ffadf8046435c76e7bc2247bbb63c00bd1a709c6544b"
  end

  resource "setuptools" do
    url "https:files.pythonhosted.orgpackagesac110a953274017ca5c33a9831bc5e052e825d174a3551bd18924777794c8162setuptools-74.1.0.tar.gz"
    sha256 "bea195a800f510ba3a2bc65645c88b7e016fe36709fefc58a880c4ae8a0138d7"
  end

  # Fix library search path on non-usrlocal installs (e.g. Apple Silicon)
  # See: https:github.comHomebrewhomebrew-coreissues75020
  #      https:gitlab.gnome.orgGNOMEgobject-introspection-merge_requests273
  patch do
    url "https:gitlab.gnome.orgtschoonjgobject-introspection-commita7be304478b25271166cd92d110f251a8742d16b.diff"
    sha256 "740c9fba499b1491689b0b1216f9e693e5cb35c9a8565df4314341122ce12f81"
  end

  # Backport removed distutils.msvccompiler
  patch do
    url "https:gitlab.gnome.orgGNOMEgobject-introspection-commita2139dba59eac283a7f543ed737f038deebddc19.diff"
    sha256 "62c1e9816effdb2f2d50bc577ea36b875cdd5e38f67ddb27eb0e0c380fa29700"
  end

  def install
    venv = virtualenv_create(libexec, "python3.12")
    venv.pip_install resources
    ENV.prepend_path "PATH", venv.root"bin"

    ENV["GI_SCANNER_DISABLE_CACHE"] = "true"
    if OS.mac? && MacOS.version == :ventura && DevelopmentTools.clang_build_version == 1500
      ENV.append "LDFLAGS", "-Wl,-ld_classic"
    end

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