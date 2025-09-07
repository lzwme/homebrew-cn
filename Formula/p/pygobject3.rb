class Pygobject3 < Formula
  desc "GNOME Python bindings (based on GObject Introspection)"
  homepage "https://pygobject.gnome.org"
  url "https://download.gnome.org/sources/pygobject/3.54/pygobject-3.54.0.tar.gz"
  sha256 "4652a7cc7ff950a5099d56ac61a78c144629c20f8855a1306933b46b10f3b417"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any, arm64_sequoia: "e5bb5346fbbe1026f85beb8a2ba33557d553e67425bf4e5d90cfa98a0706cc80"
    sha256 cellar: :any, arm64_sonoma:  "59c117f1e5ba5850598d43732d949c99e2deaad31fe0074dff7c5693393cfc49"
    sha256 cellar: :any, arm64_ventura: "004f148f9fd7c67e82ebb1b6bb93fd5a8e01c453fda06780396f148ddc9ce249"
    sha256 cellar: :any, sonoma:        "396c316a9431ed889a861401deaa91a010b68633eb4e97dfcd3d41fe6a9d6448"
    sha256 cellar: :any, ventura:       "94be140afbe541b5dc6ac08c26c11c8fa024fbf23355873543c36dbb4730a6ef"
    sha256               arm64_linux:   "356c8e10823cf2620a31b2fda751f58887f8addb372fb7577d5353787c37570f"
    sha256               x86_64_linux:  "37ed877260ac529465799bd3656eeaf3a4c77a2dc1fed029cfc5a95752e659ad"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.12" => [:build, :test]
  depends_on "python@3.13" => [:build, :test]

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