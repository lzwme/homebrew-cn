class Numpy < Formula
  desc "Package for scientific computing with Python"
  homepage "https:www.numpy.org"
  url "https:files.pythonhosted.orgpackages471b1d565e0f6e156e1522ab564176b8b29d71e13d8caf003a08768df3d5cec5numpy-2.2.0.tar.gz"
  sha256 "140dd80ff8981a583a60980be1a655068f8adebf7a45a06a6858c873fcdcd4a0"
  license "BSD-3-Clause"
  head "https:github.comnumpynumpy.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "44a0c58d7bf3b5939a94791f0c55136a85d930f5f8dfd8ee7a52e1e73264a4c4"
    sha256 cellar: :any,                 arm64_sonoma:  "8ac52b87d751af1a1abb2b8fc9174f772235336993912d05a39319a121d42cc2"
    sha256 cellar: :any,                 arm64_ventura: "8f7b365bf4faab4eb4774e36c1c4263692687716d204b16ebfa027ab794e12d1"
    sha256 cellar: :any,                 sonoma:        "d67ade8b999d910df676ef6c558c0832f2a62011c54df67f0b05940c7b7981d8"
    sha256 cellar: :any,                 ventura:       "dff7a085d4af497e738cfc576dee9a70022fc0906dfe25e706896182f31da78c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e7636d6675ba8bbbeb26e8b9f333c4678466de7d73bdcd08eb2514589febba84"
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