class PythonMpmath < Formula
  desc "Python library for floating-point arithmetic with arbitrary precision"
  homepage "https://mpmath.org"
  url "https://files.pythonhosted.org/packages/e0/47/dd32fa426cc72114383ac549964eecb20ecfd886d1e5ccf5340b55b02f57/mpmath-1.3.0.tar.gz"
  sha256 "7a28eb2a9774d00c7bc92411c19a89209d5da7c4c9a9e227be8330a23a25b91f"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e8ddb8855fea2cf189230f56d9ab93b5d085128040554fadd409a55aad5a445e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "df8d9628f0bec1eb5292d9c30b68955880ed95316da07f4b3a53af41b252e433"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "74ca629adb8178dd5a06cdf40557fa5aff71158fa3a195272f3e156cbc1fddab"
    sha256 cellar: :any_skip_relocation, sonoma:         "100dd68c16f3195ee34d4c3e41df753a365b8b3add842f7adfa3dbf7ee58c7c1"
    sha256 cellar: :any_skip_relocation, ventura:        "b7abb5e6f4c90bc2b4eea051770ed983f7cac6d6b13a8d101913e922c5485616"
    sha256 cellar: :any_skip_relocation, monterey:       "71dd7d66a52c6672e1ea0c0e6b36b2762c7d78ddd8d93f3d1a00e2eb02c506e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "21595397169a39097ae8edb7744a02e611bf123534103395cc7bf5486a273e90"
  end

  depends_on "python-setuptools" => :build
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]

  def pythons
    deps.map(&:to_formula).sort_by(&:version).filter { |f| f.name.start_with?("python@") }
  end

  def install
    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, "-m", "pip", "install", *std_pip_args, "."
    end
  end

  test do
    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, "-c", "import mpmath"
    end
  end
end