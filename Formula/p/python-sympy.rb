class PythonSympy < Formula
  desc "Python library for symbolic mathematics"
  homepage "https://www.sympy.org"
  url "https://files.pythonhosted.org/packages/e5/57/3485a1a3dff51bfd691962768b14310dae452431754bfc091250be50dd29/sympy-1.12.tar.gz"
  sha256 "ebf595c8dac3e0fdc4152c51878b498396ec7f30e7a914d6071e674d49420fb8"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c1e92a463ffee94109bdd8feb3bf47e07bd970a41e02e65abd2eb38ccdba7160"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ab5737e9dfaf9e91b5a7f1e94cb6bcfeb464c51b4a3d5a9fd9e15ec3f50057c3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b514d9feb0d3bb49314dc825ecf1e19329b58c98dd8e094716951cbfef36a4ad"
    sha256 cellar: :any_skip_relocation, sonoma:         "91764b29813dbed9e67e7f5b868257a36b6ff00b7c6858a0d84d5b0dd9e94453"
    sha256 cellar: :any_skip_relocation, ventura:        "bb486f7ccf56e7636392be9991ec3048492376a01c48d846b1bacf36a7727c37"
    sha256 cellar: :any_skip_relocation, monterey:       "3e3850d9e19bf59940be9c613acc2c7a58ce3e2845dfc545b1d1026b60329a03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2a77f00f79257af0c6c16ae6b20424c1df9577e228bb6b1f8d4da22d1fbff343"
  end

  depends_on "python-setuptools" => :build
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]
  depends_on "python-mpmath"

  def pythons
    deps.map(&:to_formula).sort_by(&:version).filter { |f| f.name.start_with?("python@") }
  end

  def install
    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, "-m", "pip", "install", *std_pip_args, "."
    end
  end

  def caveats
    <<~EOS
      To run `isympy`, you may need to `brew install #{pythons.last}`
    EOS
  end

  test do
    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, "-c", "import sympy"
    end
  end
end