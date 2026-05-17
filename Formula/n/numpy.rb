class Numpy < Formula
  desc "Package for scientific computing with Python"
  homepage "https://www.numpy.org/"
  url "https://files.pythonhosted.org/packages/50/8e/b8041bc719f056afd864478029d52214789341ac6583437b0ee5031e9530/numpy-2.4.5.tar.gz"
  sha256 "ca670567a5683b7c1670ec03e0ddd5862e10934e92a70751d68d7b7b74ca7f9f"
  license "BSD-3-Clause"
  compatibility_version 1
  head "https://github.com/numpy/numpy.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "82fb66fd359ba8f1c95b62cc37bc3b6d30e37c44b75154c1b1c86301ddf1fe95"
    sha256 cellar: :any,                 arm64_sequoia: "2f2e99a57827543d13252b81abe6c401dd3ae23d5bc65fd20c04adf10ddc09f2"
    sha256 cellar: :any,                 arm64_sonoma:  "1e927df5b0c4ebc421ce64338846964f74c2516593f68410116de6bb53e8e59d"
    sha256 cellar: :any,                 sonoma:        "b8d4ed8314dfefd78f6f676cd3a05cbd9aac64353d2cd40b72c7b5ab7e489016"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "02bfbc334588a25e09dbbd45725da3ac54ae2ed1690349f04c0705ef95b07a68"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3cf37f4dc8239d3b80883305b980b2c3bd7fa9115c721bf372636e356c1c5e47"
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