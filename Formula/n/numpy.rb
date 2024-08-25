class Numpy < Formula
  desc "Package for scientific computing with Python"
  homepage "https:www.numpy.org"
  url "https:files.pythonhosted.orgpackages54a4f8188c4f3e07f7737683588210c073478abcb542048cf4ab6fedad0b458anumpy-2.1.0.tar.gz"
  sha256 "7dc90da0081f7e1da49ec4e398ede6a8e9cc4f5ebe5f9e06b443ed889ee9aaa2"
  license "BSD-3-Clause"
  head "https:github.comnumpynumpy.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "f8b9106e874145f739e1d0d8e830abbda9c6a720d2d94123f29fcf71e904591d"
    sha256 cellar: :any,                 arm64_ventura:  "dcc75bc8b9413a51ed4a64aa99ab66e8b44d3dfdf0b2ebda6e5c8739bb1e39ee"
    sha256 cellar: :any,                 arm64_monterey: "33aedc58b41ba4610ac558e282b630a73feb4333d1d616bab684f0c81854bbb9"
    sha256 cellar: :any,                 sonoma:         "4d0d6b5cbbe22218b92d7d6b2dbc9ba2e80905571100aaf43e1f2776731cd176"
    sha256 cellar: :any,                 ventura:        "8f0b5e0fd396d9d4863e65473af1a9117ebc050bcb44b7001319acf3ac992dd3"
    sha256 cellar: :any,                 monterey:       "c1182d179acd51e221f64d2d7e99277be91e548a1231fe2ea2f39d8e948026d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8d6a36aa720449ecdad80cbf3f89b16c2089aa0a92ce9cca584616ed46f59545"
  end

  depends_on "gcc" => :build # for gfortran
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]
  depends_on "openblas"

  on_linux do
    depends_on "patchelf" => :build
  end

  fails_with gcc: "5"

  def pythons
    deps.map(&:to_formula)
        .select { |f| f.name.start_with?("python@") }
        .sort_by(&:version) # so scripts like `binf2py` use newest python
  end

  def install
    pythons.each do |python|
      python3 = python.opt_libexec"binpython"
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
      python3 = python.opt_libexec"binpython"
      system python3, "-c", <<~EOS
        import numpy as np
        t = np.ones((3,3), int)
        assert t.sum() == 9
        assert np.dot(t, t).sum() == 27
      EOS
    end
  end
end