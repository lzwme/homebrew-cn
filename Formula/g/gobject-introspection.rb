class GobjectIntrospection < Formula
  include Language::Python::Shebang
  include Language::Python::Virtualenv

  desc "Generate introspection data for GObject libraries"
  homepage "https:gi.readthedocs.ioenlatest"
  url "https:download.gnome.orgsourcesgobject-introspection1.82gobject-introspection-1.82.0.tar.xz"
  sha256 "0f5a4c1908424bf26bc41e9361168c363685080fbdb87a196c891c8401ca2f09"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.0-or-later", "MIT"]

  bottle do
    rebuild 1
    sha256 arm64_sequoia: "8c7ea27f7c13481871d27c50ea03c77412b5fe44131a5c548a100fd7c286269a"
    sha256 arm64_sonoma:  "fcbf404243d12ca9f41a326efb2df79d1d2a3be9daa1b67e8c2eec4dfcecacc8"
    sha256 arm64_ventura: "29b8666f8fb847410b974487571d1532ad22ecebc5d14e5159023bd3cd0ec26b"
    sha256 sonoma:        "4114aec82418c561da36503cacf909073bdfc1e95f3a72e4daec98d588b93f89"
    sha256 ventura:       "e6c49d63be1207e36dfce7090d1070e9bc94bb5765771c201e07365a1a0febd1"
    sha256 x86_64_linux:  "52311726849f54015d1d233a2a5380d137dc6576eb117b19b419cd190efabc3f"
  end

  depends_on "bison" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "cairo"
  depends_on "glib"
  depends_on "pkg-config"
  # Ships a `_giscanner.cpython-312-darwin.so`, so needs a specific version.
  depends_on "python@3.13"

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
    url "https:files.pythonhosted.orgpackages3e2cf0a538a2f91ce633a78daaeb34cbfb93a54bd2132a6de1f6cec028eee6efsetuptools-74.1.2.tar.gz"
    sha256 "95b40ed940a1c67eb70fc099094bd6e99c6ee7c23aa2306f4d2697ba7916f9c6"
  end

  # Fix library search path on non-usrlocal installs (e.g. Apple Silicon)
  # See: https:github.comHomebrewhomebrew-coreissues75020
  #      https:gitlab.gnome.orgGNOMEgobject-introspection-merge_requests273
  patch do
    url "https:gitlab.gnome.orgtschoonjgobject-introspection-commita7be304478b25271166cd92d110f251a8742d16b.diff"
    sha256 "740c9fba499b1491689b0b1216f9e693e5cb35c9a8565df4314341122ce12f81"
  end

  def install
    venv = virtualenv_create(libexec, "python3.13")
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
    (testpath"main.c").write <<~C
      #include <girepository.h>

      int main (int argc, char *argv[]) {
        GIRepository *repo = g_irepository_get_default();
        g_assert_nonnull(repo);
        return 0;
      }
    C

    pkg_config_flags = shell_output("pkg-config --cflags --libs gobject-introspection-1.0").strip.split
    system ENV.cc, "main.c", "-o", "test", *pkg_config_flags
    system ".test"
  end
end