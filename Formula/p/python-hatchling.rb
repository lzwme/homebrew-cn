class PythonHatchling < Formula
  desc "Modern, extensible Python build backend"
  homepage "https://github.com/pypa/hatch/tree/master/backend"
  url "https://files.pythonhosted.org/packages/e3/57/87da2c5adc173950ebe9f1acce4d5f2cd0a960783992fd4879a899a0b637/hatchling-1.18.0.tar.gz"
  sha256 "50e99c3110ce0afc3f7bdbadff1c71c17758e476731c27607940cfa6686489ca"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "40585512588943a1d1b2f172853591258d9e04cc56548984d9bbf840a0e5a602"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "385d0f6148e4c68c2f4f8d73db4f02bbc5f2b27f4c1dd63f7458cbccf1783fac"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c0226db0190cf76954950f7cc77bc1450ef13e9392fa15522f0325d5edb923e6"
    sha256 cellar: :any_skip_relocation, sonoma:         "98bcb3bd4d38a864a8f0379231f93207eb66635410a88b52ea0d49d5846c1fd2"
    sha256 cellar: :any_skip_relocation, ventura:        "d85d12902558e8376011b300c07aa46c5c2546e0134e2cdc8c87f1289180b34e"
    sha256 cellar: :any_skip_relocation, monterey:       "0dbda1cf944f4a446882f5cbe6881739c2ebfb20b592fae11ab0220535c89cae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "622d5f5c2ca82cbb86fd94a962ab12e85048b63fd4fd59ffb2562c6b0f3920da"
  end

  depends_on "python-setuptools" => :build
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]
  depends_on "python-packaging"
  depends_on "python-pathspec"
  depends_on "python-pluggy"
  depends_on "python-trove-classifiers"

  resource "editables" do
    url "https://files.pythonhosted.org/packages/01/b0/a2a87db4b6cb8e7d57004b6836faa634e0747e3e39ded126cdbe5a33ba36/editables-0.3.tar.gz"
    sha256 "167524e377358ed1f1374e61c268f0d7a4bf7dbd046c656f7b410cde16161b1a"
  end

  def pythons
    deps.map(&:to_formula).sort_by(&:version).filter { |f| f.name.start_with?("python@") }
  end

  def install
    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"

      resource("editables").stage do
        system python_exe, "-m", "pip", "install", *std_pip_args, "."
      end

      system python_exe, "-m", "pip", "install", *std_pip_args, "."

      pyversion = Language::Python.major_minor_version(python_exe)
      bin.install bin/"hatchling" => "hatchling-#{pyversion}"

      next if python != pythons.max_by(&:version)

      # The newest one is used as the default
      bin.install_symlink "hatchling-#{pyversion}" => "hatchling"
    end
  end

  def caveats
    <<~EOS
      To run `hatchling`, you may need to `brew install #{pythons.last}`
    EOS
  end

  test do
    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, "-c", "import hatchling"
    end
  end
end