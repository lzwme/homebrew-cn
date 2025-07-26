class Numpy < Formula
  desc "Package for scientific computing with Python"
  homepage "https://www.numpy.org/"
  url "https://files.pythonhosted.org/packages/37/7d/3fec4199c5ffb892bed55cff901e4f39a58c81df9c44c280499e92cad264/numpy-2.3.2.tar.gz"
  sha256 "e0486a11ec30cdecb53f184d496d1c6a20786c81e55e41640270130056f8ee48"
  license "BSD-3-Clause"
  head "https://github.com/numpy/numpy.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "94e1574d0dd23e0a2abd5c926020998dfdd913ef0cdfd714e04e69e81ec17699"
    sha256 cellar: :any,                 arm64_sonoma:  "846d2df4274515dc5b30db7b1272a7b699e3ccd0077a7d7e3a3b6ad536a5ed3c"
    sha256 cellar: :any,                 arm64_ventura: "035357f8b394f7921e0aef7698b31071a47d36cf9ea3a1d17b9df450c8f1c5c8"
    sha256 cellar: :any,                 sonoma:        "7bd78f32c65e4997a5471de972911a671746d0f62192412b3e2d474313f05985"
    sha256 cellar: :any,                 ventura:       "a87557e21a6ade4c92000156ad1d9268b5404a79635b9110eadfc7f2348d54e2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fff34d2d8ebe65428c939b8cdf9429c8b52b45b64f862ccee963e5119f571d56"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "807fe716734a45b22bbbcf05be80dad0c42976fd8674f7887fb04bbd32cd07bd"
  end

  depends_on "gcc" => :build # for gfortran
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "python@3.12" => [:build, :test]
  depends_on "python@3.13" => [:build, :test]
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