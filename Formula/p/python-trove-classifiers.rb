class PythonTroveClassifiers < Formula
  desc "Canonical source for classifiers on PyPI"
  homepage "https:github.compypatrove-classifiers"
  url "https:files.pythonhosted.orgpackagesc5e91deb1b8113917aa735b08ef21821f3533bda2eb1fa1a16e07256dd05918ftrove-classifiers-2024.3.25.tar.gz"
  sha256 "6de68d06edd6fec5032162b6af22e818a4bb6f4ae2258e74699f8a41064b7cad"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "60b794b825880dce65e9024a83930814c42be20b2cac8c4f162e92d83fe86eed"
  end

  disable! date: "2024-07-05", because: "does not meet homebrewcore's requirements for Python library formulae"

  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]

  def pythons
    deps.map(&:to_formula).sort_by(&:version).filter { |f| f.name.start_with?("python@") }
  end

  def install
    pythons.each do |python|
      python_exe = python.opt_libexec"binpython"
      system python_exe, "-m", "pip", "install", *std_pip_args(build_isolation: true), "."
    end
  end

  def caveats
    <<~EOS
      Additional details on upcoming formula removal are available at:
      * https:github.comHomebrewhomebrew-coreissues157500
      * https:docs.brew.shPython-for-Formula-Authors#libraries
      * https:docs.brew.shHomebrew-and-Python#pep-668-python312-and-virtual-environments
    EOS
  end

  test do
    pythons.each do |python|
      python_exe = python.opt_libexec"binpython"
      classifiers = shell_output("#{python_exe} -m trove_classifiers")
      assert_match "Environment :: MacOS X", classifiers
    end
  end
end