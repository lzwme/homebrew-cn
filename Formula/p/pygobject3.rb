class Pygobject3 < Formula
  desc "GNOME Python bindings (based on GObject Introspection)"
  homepage "https://pygobject.gnome.org"
  url "https://download.gnome.org/sources/pygobject/3.56/pygobject-3.56.0.tar.gz"
  sha256 "4fbb5bf47524e01026f8e309dd54233eb0f75f2281392c5bf0df5d9041cc7891"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "ac853e2459fd94b982895b8b0f56e24357c5516cac34189bab95016bc6021681"
    sha256 cellar: :any, arm64_sequoia: "b01dd23737b74361e0d3297aaafcd9fdd290b2ee7bb4b76d2b845c2c73c8e9d6"
    sha256 cellar: :any, arm64_sonoma:  "f0bd8d765862d9d268054af5b86b0e8797190cedee60201ab349e3a1f21b54bd"
    sha256 cellar: :any, sonoma:        "c7ef0cee4bb5aabf15887c355eb28c258150eb8d0641b731e4af39d8ff779a55"
    sha256               arm64_linux:   "0c63bb35ab8d2193cb731c1e1554e6f8963adf6065bc23e5ab815c0f9f62a247"
    sha256               x86_64_linux:  "040e872cb57fb5603dca08688b6d3f211efc3d3b21973ec0e55b0e2d2ba97c09"
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