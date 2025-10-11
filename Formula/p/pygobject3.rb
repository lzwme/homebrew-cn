class Pygobject3 < Formula
  desc "GNOME Python bindings (based on GObject Introspection)"
  homepage "https://pygobject.gnome.org"
  url "https://download.gnome.org/sources/pygobject/3.54/pygobject-3.54.3.tar.gz"
  sha256 "a8da09134a0f7d56491cf2412145e35aa74e91d760e8f337096a1cda0b92bae7"
  license "LGPL-2.1-or-later"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "d61b61b1d994bec4f8c144b793dc761820e4d19f708b7d517677d6d6e767bcc7"
    sha256 cellar: :any, arm64_sequoia: "c963f635ea648b4156549b3be4250ef0ab26701bbae79fcf7b99cccbe051d31b"
    sha256 cellar: :any, arm64_sonoma:  "572f9a5eb818687af44c57d9e809db01f11522c902c2e2cf786d755a6f7e2b51"
    sha256 cellar: :any, sonoma:        "cba68f4f0dcab53fa90f45aeb3ea83fb4396b01e548adb02e0f00b1adfbc4554"
    sha256               arm64_linux:   "8c166611816a1f114f20ab9b784a56035360035f2c27b732869a0f7a03690b4d"
    sha256               x86_64_linux:  "fb2740d47d68d91e9cee1eec451dacbe2bf18d22692f791d8232ff012aa405cb"
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