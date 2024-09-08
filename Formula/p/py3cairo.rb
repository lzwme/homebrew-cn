class Py3cairo < Formula
  desc "Python 3 bindings for the Cairo graphics library"
  homepage "https:cairographics.orgpycairo"
  url "https:github.compygobjectpycairoreleasesdownloadv1.27.0pycairo-1.27.0.tar.gz"
  sha256 "5cb21e7a00a2afcafea7f14390235be33497a2cce53a98a19389492a60628430"
  license any_of: ["LGPL-2.1-only", "MPL-1.1"]

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b284138413f9e2b04c52b8fd18bc692fdfe04216658cd6ec310329ff63962331"
    sha256 cellar: :any,                 arm64_ventura:  "01ca0d75478aff40159ac72ed356774ea1a1ad54ca66872e709394b8b8a809af"
    sha256 cellar: :any,                 arm64_monterey: "7e31aa454d6657f749a03618ae068374d00ad072cd31bbc577ecbef0e82aa645"
    sha256 cellar: :any,                 sonoma:         "0bc26c13732313108821e0d311f72aed1f0c00b4ae12628478c42c10878fa701"
    sha256 cellar: :any,                 ventura:        "7fbf1d90015cb8fbd343c560640cfc7eb5b3df75703583e576819125a6017d6b"
    sha256 cellar: :any,                 monterey:       "7398ebaada254c54a241be654cc6d30f84b428b847d26f9ea30f7ef742dc0a1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7edf63afb34c7e2289e393891509a701c644b81a396aa77093f263534978564c"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]
  depends_on "cairo"

  def pythons
    deps.map(&:to_formula)
        .select { |f| f.name.match?(^python@\d\.\d+$) }
        .map { |f| f.opt_libexec"binpython" }
  end

  def site_packages(python)
    prefixLanguage::Python.site_packages(python)
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