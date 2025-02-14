class Numpy < Formula
  desc "Package for scientific computing with Python"
  homepage "https:www.numpy.org"
  url "https:files.pythonhosted.orgpackagesfb908956572f5c4ae52201fdec7ba2044b2c882832dcec7d5d0922c9e9acf2denumpy-2.2.3.tar.gz"
  sha256 "dbdc15f0c81611925f382dfa97b3bd0bc2c1ce19d4fe50482cb0ddc12ba30020"
  license "BSD-3-Clause"
  head "https:github.comnumpynumpy.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d3e824219498efcd74dcd3c422dbad30a1acc327a61ce95b369a94304d676f7f"
    sha256 cellar: :any,                 arm64_sonoma:  "f09320f8393d18b4d62c2b17faa7c8817b3d1fb97ac7074be6471a5c694f92fc"
    sha256 cellar: :any,                 arm64_ventura: "408885a08e26423cfed2350bc7bd9e0149bf80f5bddfa027ced98903aaf60d73"
    sha256 cellar: :any,                 sonoma:        "eab73d0c0468ea08fc270a5bb74e5f2f8509fe919548406e2774e5a896d50c2e"
    sha256 cellar: :any,                 ventura:       "138d79f15566e516327bc9c233090980e0bd38fc8b6b8324108970a36269fff1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "918114f33697a85279333fc1d4cb22477ecb397b703d532d5c3e90d9f5694c03"
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
      system python3, "-c", <<~PYTHON
        import numpy as np
        t = np.ones((3,3), int)
        assert t.sum() == 9
        assert np.dot(t, t).sum() == 27
      PYTHON
    end
  end
end