class Py3cairo < Formula
  desc "Python 3 bindings for the Cairo graphics library"
  homepage "https://cairographics.org/pycairo/"
  url "https://ghfast.top/https://github.com/pygobject/pycairo/releases/download/v1.29.2/pycairo-1.29.2.tar.gz"
  sha256 "3e69fff74fe64f5ba2dfa31f67c6bdf26413342574047437d2ac520d35e9a489"
  license any_of: ["LGPL-2.1-only", "MPL-1.1"]
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "ae8f55dd424356ded6562878fb0551b83673d2f8276b797383a27ae23e8d7419"
    sha256 cellar: :any, arm64_tahoe:       "dd941b47d3fa4fc667dc1404455cae42e67c96ea1bff1bd95932a2b5ac1c0bae"
    sha256 cellar: :any, arm64_sequoia:     "ce9d1133f153dea3cd011c383ff5cb0d4d8690491c6a89e22be799134dd0be7f"
    sha256 cellar: :any, arm64_linux:       "43ee113c1a613f0df8112691bc3756f70d573b65ab2733c40950be2ec48ae611"
    sha256 cellar: :any, x86_64_linux:      "16ee81bb6982f87fcb49eed4233a6517181e809ae6795fa87ae29fa286b5a3f4"
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