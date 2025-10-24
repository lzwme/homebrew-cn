class Cython < Formula
  desc "Compiler for writing C extensions for the Python language"
  homepage "https://cython.org/"
  url "https://files.pythonhosted.org/packages/e3/58/6a8321cc0791876dc2509d7a22fc75535a1a7aa770b3496772f58b0a53a4/cython-3.1.6.tar.gz"
  sha256 "ff4ccffcf98f30ab5723fc45a39c0548a3f6ab14f01d73930c5bfaea455ff01c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e57711fde75b27b25be18fbe65e6cda1e71a8402ce959ad439f114f0a1868a42"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "68f812f586f358bb46f6d59996bee4d40b73533102c6a5cd86c5d1042879dab2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a23dd70860cdc2262380f4bdd1bd5b0ea3f6543a7f7a207902a29c05a804793a"
    sha256 cellar: :any_skip_relocation, sonoma:        "e5a0f8878f755b196d05122846ce0b91504e62e5ec2d9e7f7ad30fb86e55c59f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0345ed2901daf5c30595b73ead2b96b9f027669159f9f38d73be67162ef8822d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "46bdac74bc3ab3cc21a8c535b2c73775c74708b6536966fc7bc9ec06e17289b1"
  end

  keg_only <<~EOS
    this formula is mainly used internally by other formulae.
    Users are advised to use `pip` to install cython
  EOS

  depends_on "python-setuptools" => [:build, :test]
  depends_on "python@3.14"

  def python3
    "python3.14"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/Language::Python.site_packages(python3)
    system python3, "-m", "pip", "install", *std_pip_args(prefix: libexec), "."

    bin.install (libexec/"bin").children
    bin.env_script_all_files(libexec/"bin", PYTHONPATH: ENV["PYTHONPATH"])
  end

  test do
    ENV.prepend_path "PYTHONPATH", libexec/Language::Python.site_packages(python3)

    phrase = "You are using Homebrew"
    (testpath/"package_manager.pyx").write "print '#{phrase}'"
    (testpath/"setup.py").write <<~PYTHON
      from distutils.core import setup
      from Cython.Build import cythonize

      setup(
        ext_modules = cythonize("package_manager.pyx")
      )
    PYTHON
    system python3, "setup.py", "build_ext", "--inplace"
    assert_match phrase, shell_output("#{python3} -c 'import package_manager'")
  end
end