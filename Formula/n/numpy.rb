class Numpy < Formula
  desc "Package for scientific computing with Python"
  homepage "https:www.numpy.org"
  url "https:files.pythonhosted.orgpackages595f9003bb3e632f2b58f5e3a3378902dcc73c5518070736c6740fe52454e8e1numpy-2.1.1.tar.gz"
  sha256 "d0cf7d55b1051387807405b3898efafa862997b4cba8aa5dbe657be794afeafd"
  license "BSD-3-Clause"
  head "https:github.comnumpynumpy.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "924c40ddf282d5c12b4376f33271b7850a51422cb275d5e4d6a088efaba20d33"
    sha256 cellar: :any,                 arm64_ventura:  "a59680ff0599eaaedffc08d39e43886b7f30bfd4329834a80037938f52a14cce"
    sha256 cellar: :any,                 arm64_monterey: "4c66cadb1690ea8f562ab3e6cdfe7850a7d87d434edbad84134313bda4e61e03"
    sha256 cellar: :any,                 sonoma:         "fa860a99fcc55b4a2da17e44d0de97097f9084d04f926273a4f20c517280c318"
    sha256 cellar: :any,                 ventura:        "462ace65c75c44be7c79a05c5a9a4bb041b1e6f811cf706c8622b27555c6a2c6"
    sha256 cellar: :any,                 monterey:       "cc238b3c89f76848d5e2a1c995b28367fa880b841a02d9ee8f04f7670afc87a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "24ef8697b15867bc22a393c6b7ead92bea61964c4b63fb5020021329ee499f96"
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