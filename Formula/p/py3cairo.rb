class Py3cairo < Formula
  desc "Python 3 bindings for the Cairo graphics library"
  homepage "https://cairographics.org/pycairo/"
  url "https://ghfast.top/https://github.com/pygobject/pycairo/releases/download/v1.28.0/pycairo-1.28.0.tar.gz"
  sha256 "26ec5c6126781eb167089a123919f87baa2740da2cca9098be8b3a6b91cc5fbc"
  license any_of: ["LGPL-2.1-only", "MPL-1.1"]
  revision 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "2c77e291f2095afb6e2d2904b2c64e43840de2d8d3b4819bddf52d136f1dadee"
    sha256 cellar: :any, arm64_sequoia: "b77c713e6aa751c3506635993c0b64efcd61ef54eb73d25ec589293ae8ce4c4f"
    sha256 cellar: :any, arm64_sonoma:  "10aa68f1f543afce5df0864afa7fed6e231afe0d3d39054e3e8bce0cddb3a59d"
    sha256 cellar: :any, sonoma:        "f188206fc23ce8575ade7b42ff4590f42f3f7b04183cf5c8c1fbc140556ffb1a"
    sha256               arm64_linux:   "83cfdf6e8e3a7a06d39961044cdc71e830fc218d5ac50dfc84354cc1184a861d"
    sha256               x86_64_linux:  "f3ad42b50dc9862d076c5aeb4b660b52d85b8c8b62ae8ac219b20d5450ff47ce"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.13" => [:build, :test]
  depends_on "python@3.14" => [:build, :test]
  depends_on "cairo"

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
      python_version = Language::Python.major_minor_version(python)
      builddir = "build#{python_version}"
      system "meson", "setup", builddir, "-Dpython=#{python}",
                                         "-Dpython.platlibdir=#{site_packages(python)}",
                                         "-Dpython.purelibdir=#{site_packages(python)}",
                                         *std_meson_args
      system "meson", "compile", "-C", builddir
      system "meson", "install", "-C", builddir
    end
  end

  test do
    pythons.each do |python|
      system python, "-c", "import cairo; print(cairo.version)"
    end
  end
end