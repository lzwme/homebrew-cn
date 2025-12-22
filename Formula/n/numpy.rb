class Numpy < Formula
  desc "Package for scientific computing with Python"
  homepage "https://www.numpy.org/"
  url "https://files.pythonhosted.org/packages/a4/7a/6a3d14e205d292b738db449d0de649b373a59edb0d0b4493821d0a3e8718/numpy-2.4.0.tar.gz"
  sha256 "6e504f7b16118198f138ef31ba24d985b124c2c469fe8467007cf30fd992f934"
  license "BSD-3-Clause"
  head "https://github.com/numpy/numpy.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "687b2413356c1a7709b63fcb9f6cbc5c29313ae91fdf66ba47f9af130a0b1d35"
    sha256 cellar: :any,                 arm64_sequoia: "d54d358eb0397b42964a1a07a940525ec3d22736165a0a4ede743aeed8ff5677"
    sha256 cellar: :any,                 arm64_sonoma:  "902803e630a7220320f0ca166a34882cef64346ef493ebf1e04f30e2f392c937"
    sha256 cellar: :any,                 sonoma:        "066eb52a1f06e3075cfdfbbe5af8c4551ef786917df308404d8fe5ebe600bce8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3090c89123eb349a8c2f12e05545997df2476e11475ab1528ee04f392092d2f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "11c40234ee90990e129215b5371af2e2e9ee12f62c0d5c8fdafede910c7bac74"
  end

  depends_on "gcc" => :build # for gfortran
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "python@3.13" => [:build, :test]
  depends_on "python@3.14" => [:build, :test]
  depends_on "openblas"

  on_linux do
    depends_on "patchelf" => :build
  end

  def pythons
    deps.map(&:to_formula)
        .select { |f| f.name.start_with?("python@") }
        .sort_by(&:version) # so scripts like `bin/f2py` use newest python
  end

  def install
    pythons.each do |python|
      python3 = python.opt_libexec/"bin/python"
      system python3, "-m", "pip", "install", "-Csetup-args=-Dblas=openblas",
                                              "-Csetup-args=-Dlapack=openblas",
                                              *std_pip_args(build_isolation: true), "."
    end
  end

  def caveats
    <<~EOS
      To run `f2py`, you may need to `brew install #{pythons.last}`
    EOS
  end

  test do
    pythons.each do |python|
      python3 = python.opt_libexec/"bin/python"
      system python3, "-c", <<~PYTHON
        import numpy as np
        t = np.ones((3,3), int)
        assert t.sum() == 9
        assert np.dot(t, t).sum() == 27
      PYTHON
    end
  end
end