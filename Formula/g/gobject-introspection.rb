class GobjectIntrospection < Formula
  include Language::Python::Shebang

  desc "Generate introspection data for GObject libraries"
  homepage "https:gi.readthedocs.ioenlatest"
  url "https:download.gnome.orgsourcesgobject-introspection1.78gobject-introspection-1.78.1.tar.xz"
  sha256 "bd7babd99af7258e76819e45ba4a6bc399608fe762d83fde3cac033c50841bb4"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.0-or-later", "MIT"]

  bottle do
    rebuild 1
    sha256 arm64_sonoma:   "025018b9b268379c594d7a079ea585962a82610632f5fa7682347d7cdb031755"
    sha256 arm64_ventura:  "aeead3c8ba54d00e773d9140071a73c5736f5f20bc6c43b6483394da0e68eb98"
    sha256 arm64_monterey: "8d424f839195237aa9714ea4d5c10d79de2bd253a6b087a3e7f954f43d8b9f31"
    sha256 sonoma:         "f37f64f8ab0b15e72d0d026af7e0a1ef69bf26cd98d161c7a03db5ecd7ff13d8"
    sha256 ventura:        "e303113b7611e51e42ea3ea79675ec6cd9c4ad825c0273596bf1785a5a4af14e"
    sha256 monterey:       "b4f2b89603090bd8f9950b53ac5399c51ba1fde15cce6d4eb86ec79b91207e3c"
    sha256 x86_64_linux:   "236dac74f5dc88d7217ccabfdb17393ed6bb87ecc56ff5521ee55be41f574787"
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "cairo"
  depends_on "glib"
  depends_on "pkg-config"
  depends_on "python-setuptools"
  # Ships a `_giscanner.cpython-312-darwin.so`, so needs a specific version.
  depends_on "python@3.12"

  uses_from_macos "flex" => :build
  uses_from_macos "libffi", since: :catalina

  # Fix library search path on non-usrlocal installs (e.g. Apple Silicon)
  # See: https:github.comHomebrewhomebrew-coreissues75020
  #      https:gitlab.gnome.orgGNOMEgobject-introspection-merge_requests273
  patch do
    url "https:gitlab.gnome.orgtschoonjgobject-introspection-commita7be304478b25271166cd92d110f251a8742d16b.diff"
    sha256 "740c9fba499b1491689b0b1216f9e693e5cb35c9a8565df4314341122ce12f81"
  end

  def python3
    which("python3.12")
  end

  def install
    # Allow scripts to prioritize "python3" from correct Python during build if
    # that Python was altinstall'ed and the linked Python is also in environment
    pyver = Language::Python.major_minor_version python3
    ENV.prepend_path "PATH", Formula["python@#{pyver}"].opt_libexec"bin"

    ENV["GI_SCANNER_DISABLE_CACHE"] = "true"

    inreplace "giscannertransformer.py", "usrshare", "#{HOMEBREW_PREFIX}share"
    inreplace "meson.build",
      "config.set_quoted('GOBJECT_INTROSPECTION_LIBDIR', join_paths(get_option('prefix'), get_option('libdir')))",
      "config.set_quoted('GOBJECT_INTROSPECTION_LIBDIR', '#{HOMEBREW_PREFIX}lib')"

    system "meson", "setup", "build", "-Dpython=#{python3}",
                                      "-Dextra_library_paths=#{HOMEBREW_PREFIX}lib",
                                      *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"

    rewrite_shebang detected_python_shebang, *bin.children
  end

  test do
    resource "homebrew-tutorial" do
      url "https:gist.github.comtdsmith7a0023656ccfe309337a.git",
          revision: "499ac89f8a9ad17d250e907f74912159ea216416"
    end

    resource("homebrew-tutorial").stage testpath
    system "make"
    assert_predicate testpath"Tut-0.1.typelib", :exist?
  end
end