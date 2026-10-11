class Numpy < Formula
  desc "Package for scientific computing with Python"
  homepage "https://www.numpy.org/"
  url "https://files.pythonhosted.org/packages/13/01/11703282db468b85f6f7b8c7f22d058de5970d5c7e60a3a8aaa313c3de36/numpy-2.5.3.tar.gz"
  sha256 "df2d5874ff183595a4ba404edd04f6bd9b5505c1d7708573f6a6c17489a67563"
  license "BSD-3-Clause"
  revision 1
  compatibility_version 1
  head "https://github.com/numpy/numpy.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "a96dc2725e8139668d0d14e909e67f8158b48fad5bf1251d23c645e7aa619665"
    sha256 cellar: :any, arm64_tahoe:       "009fb161cc194dcefacfac3013dc2a1a82ca878d58f721e6f81cc46a4c3ed29d"
    sha256 cellar: :any, arm64_sequoia:     "d2082c65b8bba6319e9a9bc4357a051190aad6b88c6a320a6670da08c848f70b"
    sha256 cellar: :any, arm64_linux:       "5fd1b6887f862829d4bc71b3a06c6a912cc17c689c53b3ce906e62fc8a478b3f"
    sha256 cellar: :any, x86_64_linux:      "a3e79e950870f6ccdecab7b7526e7058dd556245afbb1f3b35a85adb7aed73c0"
  end

  depends_on "gcc" => :build # for gfortran
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "python@3.14" => [:build, :test]
  depends_on "python@3.15" => [:build, :test]
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