class PythonNetworkx < Formula
  desc "Network analysis in Python"
  homepage "https://networkx.org"
  url "https://files.pythonhosted.org/packages/c4/80/a84676339aaae2f1cfdf9f418701dd634aef9cc76f708ef55c36ff39c3ca/networkx-3.2.1.tar.gz"
  sha256 "9f1bb5cf3409bf324e0a722c20bdb4c20ee39bf1c30ce8ae499c8502b0b5e0c6"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5d1bef7983903d079feaad96a6013e90eab02571c918058d8bc64533bc916a6b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c0731e4e496774a867737ec9bfedcdf67b2fa0f556056537f3bd3911b280aa7e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "36a6068b2ac61104b3db542fb3f4224dc6516d8b5510c6f9789acddc87aee371"
    sha256 cellar: :any_skip_relocation, sonoma:         "4d7f73434361c3dabdbb30ef4865ac8726cf1c14ec71de73a9ab2961265cdb94"
    sha256 cellar: :any_skip_relocation, ventura:        "f434c0a5ba614b158729d52946e632f62d715d36106492d45f48ef894d7cfa6d"
    sha256 cellar: :any_skip_relocation, monterey:       "334a005800f35e784ec07d56480f697621c31257c8162ad75e4feccf50c65569"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e67f8dedf59b90cb98223b39bf9478591dfac6bb1d17c310840d38792e80534c"
  end

  depends_on "python-build" => :build
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]

  def pythons
    deps.map(&:to_formula).sort_by(&:version).filter { |f| f.name.start_with?("python@") }
  end

  def install
    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, "-m", "build", "--wheel", "."
      system python_exe, "-m", "pip", "install", *std_pip_args, Dir["dist/networkx-*.whl"].first
    end
  end

  test do
    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, "-c", "import networkx as nx"
    end
  end
end