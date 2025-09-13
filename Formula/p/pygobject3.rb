class Pygobject3 < Formula
  desc "GNOME Python bindings (based on GObject Introspection)"
  homepage "https://pygobject.gnome.org"
  url "https://download.gnome.org/sources/pygobject/3.54/pygobject-3.54.1.tar.gz"
  sha256 "cab149c2a58afd20100bbf3e724405275a7df317cfecbf500bd4561da76cc45f"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any, arm64_sequoia: "1e75d2989baa564146078e6c0117f147c32d0e541922ac02a6b8b60367eb18ef"
    sha256 cellar: :any, arm64_sonoma:  "b0e7bb4841d20b8122c2d842af1aa2453e6f4ca3a2fe58104288f2ad921086c7"
    sha256 cellar: :any, sonoma:        "0f3251ef0432b21b59945105e816227bbc5d764ab15e591ad20fe25f24a45284"
    sha256               arm64_linux:   "32e366ec4e4512c239b07ea24af36feabbf84bada332aab777fc58111f8b8e13"
    sha256               x86_64_linux:  "b38c10ff6f2ea173b3e4860593d21ce8696d899c4af7608290c8e6aeaca8ab2b"
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