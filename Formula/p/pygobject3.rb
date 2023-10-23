class Pygobject3 < Formula
  desc "GNOME Python bindings (based on GObject Introspection)"
  homepage "https://wiki.gnome.org/Projects/PyGObject"
  url "https://download.gnome.org/sources/pygobject/3.46/pygobject-3.46.0.tar.xz"
  sha256 "426008b2dad548c9af1c7b03b59df0440fde5c33f38fb5406b103a43d653cafc"
  license "LGPL-2.1-or-later"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "67f1311909ef73e7979b64a22d4093685567a8659c8d42c42c82919095364094"
    sha256 cellar: :any, arm64_ventura:  "b8ba69e7aad0ccffbb266e2c29731e5140cc3fdb920c4b847689a4e76539e056"
    sha256 cellar: :any, arm64_monterey: "0d2b091dfc7910c3d225431f3cc950ce393cb3486b10e7e50fa7079e39d2b290"
    sha256 cellar: :any, sonoma:         "cc4a132bdefae49e8147d8db3ffeb86c82c528bce2ffd51e652d913f0a376b0c"
    sha256 cellar: :any, ventura:        "f61d07a303cef9e600301d80452c5ba4b3f782d6d9fc34578749439bbeee601b"
    sha256 cellar: :any, monterey:       "14baa25fcb45daffc6419668ac6b8eb0fb22c52c11e74264e19bcb5c0dbfe061"
    sha256               x86_64_linux:   "934fa9922746ffdc10718b45cbc28c084dd631565d5e64b982a47731a1ce712f"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python-setuptools" => :build
  depends_on "python@3.10" => [:build, :test]
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]
  depends_on "gobject-introspection"
  depends_on "py3cairo"

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