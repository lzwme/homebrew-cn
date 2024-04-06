class Pygobject3 < Formula
  desc "GNOME Python bindings (based on GObject Introspection)"
  homepage "https://wiki.gnome.org/Projects/PyGObject"
  url "https://download.gnome.org/sources/pygobject/3.48/pygobject-3.48.1.tar.xz"
  sha256 "3a0a2c0c0f25931b5840649c54834b9e58a63148d37fa9f6308887b7027e15c2"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "92678e401e4fbae287fed9a2140187ba8773d839cfb3d1028f9257d7c86bb19a"
    sha256 cellar: :any, arm64_ventura:  "b67c553fd0a26ada44536fb7c1d8ff9d8dc5047bc4ca0525a01c33a7d8d40476"
    sha256 cellar: :any, arm64_monterey: "9025e185ca09e9aad8b1e47248b049920c045db4e2ed0511492bcde2b7462f70"
    sha256 cellar: :any, sonoma:         "a62905ab0de96286b2772668ac97f364441d9441552ac0220f045fe9abd147be"
    sha256 cellar: :any, ventura:        "60695f35a2be78b9ea472963de2bb7a803e1fd765eead878d9c50485a8617332"
    sha256 cellar: :any, monterey:       "f5ad614dbab8682eb7505323df49d829aa7305b08fdea3745b1d0a936c5b521c"
    sha256               x86_64_linux:   "bbc37eddc4009446caf9bf3be6b0b4a7ce3bef5a49cd0c26365812e3df9d22b5"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python-setuptools" => :build
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]
  depends_on "gobject-introspection"
  depends_on "py3cairo"

  # Fix support for fundamental types using commits from open MR.
  # Ref: https://gitlab.gnome.org/GNOME/pygobject/-/merge_requests/304
  patch do
    url "https://gitlab.gnome.org/GNOME/pygobject/-/commit/d6d937e3da5791420f17b83cf4caaceab1c0e1b9.diff"
    sha256 "3a907e7d390bc56bc72aad553164cb8515a22d670a08f344531eedf395a8fddc"
  end
  patch do
    url "https://gitlab.gnome.org/GNOME/pygobject/-/commit/27d34e4c1d24d8f8f15035b18630a00d7c5d2e26.diff"
    sha256 "60b10f6661cd45f6467f97375eb3b503c08450e43588701cc04166358dca77a4"
  end

  def pythons
    deps.map(&:to_formula)
        .select { |f| f.name.match?(/^python@\d\.\d+$/) }
        .map { |f| f.opt_libexec/"bin/python" }
  end

  def site_packages(python)
    prefix/Language::Python.site_packages(python)
  end

  def install
    pythons.each do |python|
      xy = Language::Python.major_minor_version(python)
      builddir = "buildpy#{xy}".delete(".")

      system "meson", "setup", builddir, "-Dpycairo=enabled",
                                         "-Dpython=#{python}",
                                         "-Dpython.platlibdir=#{site_packages(python)}",
                                         "-Dpython.purelibdir=#{site_packages(python)}",
                                         "-Dtests=false",
                                         *std_meson_args
      system "meson", "compile", "-C", builddir, "--verbose"
      system "meson", "install", "-C", builddir
    end
  end

  test do
    Pathname("test.py").write <<~EOS
      import gi
      gi.require_version("GLib", "2.0")
      assert("__init__" in gi.__file__)
      from gi.repository import GLib
      assert(31 == GLib.Date.get_days_in_month(GLib.DateMonth.JANUARY, 2000))
    EOS

    pythons.each do |python|
      system python, "test.py"
    end
  end
end