class Pygobject3 < Formula
  desc "GNOME Python bindings (based on GObject Introspection)"
  homepage "https://pygobject.gnome.org"
  url "https://download.gnome.org/sources/pygobject/3.58/pygobject-3.58.1.tar.gz"
  sha256 "4c80598ade17fbaa7798e01a25d0bf29ce109740786026a074c5c62bb3e79d23"
  license "LGPL-2.1-or-later"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "67d25c342b2782732307f63e75090f4a1aa1c71c90e71e6b76762c616f535643"
    sha256 cellar: :any, arm64_tahoe:       "051de3dcdffb1a4293a248f2e7f24898809018279a73acf85bc3288bcf9e4ef9"
    sha256 cellar: :any, arm64_sequoia:     "fe42393602b7a076beafa984296fb173256a96e5b269468d1dfefba5c81e0750"
    sha256 cellar: :any, arm64_linux:       "10617d90191b5ea0c62a8d5b7a5332304c3eea7720c6a19e24583e0f6461f5e4"
    sha256 cellar: :any, x86_64_linux:      "f25d6daf251bf93807fbaed0ec98a583ee15c4b1fe101111a076d68a550719ea"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.13" => [:build, :test]
  depends_on "python@3.14" => [:build, :test]

  depends_on "cairo"
  depends_on "glib"
  depends_on "gobject-introspection"
  depends_on "py3cairo"

  uses_from_macos "libffi"

  def pythons
    deps.map(&:to_formula)
        .select { |f| f.name.match?(/^python@\d\.\d+$/) }
        .map { |f| f.opt_libexec/"bin/python" }
  end

  def install
    pythons.each do |python|
      xy = Language::Python.major_minor_version(python)
      builddir = "buildpy#{xy}".delete(".")
      site_packages = prefix/Language::Python.site_packages(python)

      system "meson", "setup", builddir, "-Dpycairo=enabled",
                                         "-Dpython=#{python}",
                                         "-Dpython.platlibdir=#{site_packages}",
                                         "-Dpython.purelibdir=#{site_packages}",
                                         "-Dtests=false",
                                         *std_meson_args
      system "meson", "compile", "-C", builddir, "--verbose"
      system "meson", "install", "-C", builddir
    end
  end

  test do
    Pathname("test.py").write <<~PYTHON
      import gi
      gi.require_version("GLib", "2.0")
      assert("__init__" in gi.__file__)
      from gi.repository import GLib
      assert(31 == GLib.Date.get_days_in_month(GLib.DateMonth.JANUARY, 2000))
    PYTHON

    pythons.each do |python|
      system python, "test.py"
    end
  end
end