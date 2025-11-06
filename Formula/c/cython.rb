class Cython < Formula
  desc "Compiler for writing C extensions for the Python language"
  homepage "https://cython.org/"
  url "https://files.pythonhosted.org/packages/52/82/01f0b63287cb922e5ba96c5147c30f1e51f541ce91bd178025bb3518b1ba/cython-3.2.0.tar.gz"
  sha256 "41fdce8237baee2d961c292ed0386903dfe126f131e450a62de0fd7a5280d4b2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8ce354a588740165701893974a9bb8e333ceb463bf142cdbbf3a744235c2907f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f6645d0ed44d87b53fa80b4fc9e3c57ddc012c75a35581813446cf3bc4dd98dd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5fb27889e83d59b8321af6062b2b70985f074e26f6bbee5881cd9ce2f2b560d3"
    sha256 cellar: :any_skip_relocation, sonoma:        "52f8ca0132696dc1618dba8de26f1a4b28db0e86511a9fd8d9bbf457ca6b9eba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "19a5b921e67d6f5ea053dc5113609a3b2e887435e9c917ccd14ad715a83776f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4417a6f79e70d513ff3795ebfadca19c75ab2e8bb51680e5d6142bb72ebca641"
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