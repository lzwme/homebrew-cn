class PythonPathspec < Formula
  desc "Utility library for gitignore style pattern matching of file paths"
  homepage "https://github.com/cpburnz/python-pathspec"
  url "https://files.pythonhosted.org/packages/a0/2a/bd167cdf116d4f3539caaa4c332752aac0b3a0cc0174cdb302ee68933e81/pathspec-0.11.2.tar.gz"
  sha256 "e0d8d0ac2f12da61956eb2306b69f9469b42f4deb0f3cb6ed47b9cce9996ced3"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6efed506957d0ee13629b91611da115fcc5dfc88e7a302c865d916f66872cfa9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "179241c63484fc67d4ec3384079f31b2ac5c3b82f906886e0a4e6f3a2dbbd1c4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fce55aeeae1c5cc865a0ba0ab79050fdc1cafe38a9445e618f51d1b262d0b9bd"
    sha256 cellar: :any_skip_relocation, sonoma:         "c4ba34a88e66d5fbfb509a5de3b49d4d91efcedd385782208844231f489bc4a0"
    sha256 cellar: :any_skip_relocation, ventura:        "463c426fa0b4f7839bef49afc8d1d5b434601aa37d486190c8e32d30d1531070"
    sha256 cellar: :any_skip_relocation, monterey:       "f8df2a98bd0b316f7e9a7f597e0c64be1db187549f37030e517b814968c6770b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3826917cffa95f99d056869b663b31fbf1b3e14eeb65c4d40da3b771caf06a25"
  end

  depends_on "python-flit-core" => :build
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
      system python_exe, "-c", "import pathspec"
    end
  end
end