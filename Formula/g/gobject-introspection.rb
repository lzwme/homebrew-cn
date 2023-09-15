class GobjectIntrospection < Formula
  include Language::Python::Shebang

  desc "Generate introspection data for GObject libraries"
  homepage "https://gi.readthedocs.io/en/latest/"
  url "https://download.gnome.org/sources/gobject-introspection/1.78/gobject-introspection-1.78.0.tar.xz"
  sha256 "84f5bd2038bd52abbce74a639832c5b46a2d17e9c5a8ae14f9788e8516c04166"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.0-or-later", "MIT"]

  bottle do
    sha256 arm64_sonoma:   "d232c7d84731f329d3e0f108c0ada363fd9a2874052faea3a91477e80ad2df78"
    sha256 arm64_ventura:  "6b4ee982ddd1a6a724ae2f54dd477591efa7c48bccd75c342d2acae7eb7ff3ae"
    sha256 arm64_monterey: "ca7bc73d0fc6709ab490cbaa403aa6cdf79d2ad5e8a3b112df149ce7b26c1282"
    sha256 arm64_big_sur:  "4054a01f1538a066b61fb7229e10cde9e910e8ed6f6a6f1d14b244f12225eb37"
    sha256 sonoma:         "53e610ede9117c52b027ef382b68525e0556f69f92a59e8f7bc45dd6943a2e71"
    sha256 ventura:        "2dab70e61b9868bdab40eace98ad44cf1b9543a894a861a181e231ab5fa4a9fc"
    sha256 monterey:       "c805d29410abe00a7bcd510702e568411d7bef2fd023c49be5480daf7ca557c3"
    sha256 big_sur:        "7011af2059a2c1169b74c02558756ea13d7d7fc0488e0dab3c88b99f3eaabfc5"
    sha256 x86_64_linux:   "7f1aa60c7d14d1e5a81b3e0a90e9bfd4354d002d3353c98573dd078f3fbc59a8"
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "cairo"
  depends_on "glib"
  depends_on "pkg-config"
  # Ships a `_giscanner.cpython-311-darwin.so`, so needs a specific version.
  depends_on "python@3.11"

  uses_from_macos "flex" => :build
  uses_from_macos "libffi", since: :catalina

  # Fix library search path on non-/usr/local installs (e.g. Apple Silicon)
  # See: https://github.com/Homebrew/homebrew-core/issues/75020
  #      https://gitlab.gnome.org/GNOME/gobject-introspection/-/merge_requests/273
  patch do
    url "https://gitlab.gnome.org/tschoonj/gobject-introspection/-/commit/a7be304478b25271166cd92d110f251a8742d16b.diff"
    sha256 "740c9fba499b1491689b0b1216f9e693e5cb35c9a8565df4314341122ce12f81"
  end

  def python3
    which("python3.11")
  end

  def install
    ENV["GI_SCANNER_DISABLE_CACHE"] = "true"

    inreplace "giscanner/transformer.py", "/usr/share", "#{HOMEBREW_PREFIX}/share"
    inreplace "meson.build",
      "config.set_quoted('GOBJECT_INTROSPECTION_LIBDIR', join_paths(get_option('prefix'), get_option('libdir')))",
      "config.set_quoted('GOBJECT_INTROSPECTION_LIBDIR', '#{HOMEBREW_PREFIX}/lib')"

    system "meson", "setup", "build", "-Dpython=#{python3}",
                                      "-Dextra_library_paths=#{HOMEBREW_PREFIX}/lib",
                                      *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"

    rewrite_shebang detected_python_shebang, *bin.children
  end

  test do
    resource "homebrew-tutorial" do
      url "https://gist.github.com/tdsmith/7a0023656ccfe309337a.git",
          revision: "499ac89f8a9ad17d250e907f74912159ea216416"
    end

    resource("homebrew-tutorial").stage testpath
    system "make"
    assert_predicate testpath/"Tut-0.1.typelib", :exist?
  end
end