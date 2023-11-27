class Libcython < Formula
  desc "Compiler for writing C extensions for the Python language"
  homepage "https://cython.org/"
  url "https://files.pythonhosted.org/packages/d3/20/02f4961b4315b95989abfe4b7cedff263cc89693834222d210a7a62a6214/Cython-3.0.6.tar.gz"
  sha256 "399d185672c667b26eabbdca420c98564583798af3bc47670a8a09e9f19dd660"
  license "Apache-2.0"

  livecheck do
    formula "cython"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e6dfb1c3b42945946e8ee33d2d8bcd49b6fdffc061a1bd294fccd9a1a40a8ffb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "03b6f263ce9880cc4d091c8683a6f5aa78dbb97b16f72d00e079d5d27c58e575"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c475073fc84421546f6f80f2fb19bcf12fb7a9b640d8961acf3fff9b40cf2422"
    sha256 cellar: :any_skip_relocation, sonoma:         "56f88101cf92565a25cd685ed709a85cd867b5350cad99f4692b027a52f4cb3b"
    sha256 cellar: :any_skip_relocation, ventura:        "a2aac4dd6ecd40c1086d17137f5d44dcb34991260f1a0e1f7edc6eac3dd603ea"
    sha256 cellar: :any_skip_relocation, monterey:       "5ef75a39b28349e7bff04d26b106be3c201424958be80866d1fad8c8855f7dcb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c3a6ff2fd507b77c2917c37b3ad2552ae5a30116bc116b5ecd765922c353c2cf"
  end

  keg_only <<~EOS
    this formula is mainly used internally by other formulae.
    Users are advised to use `pip` to install cython
  EOS

  depends_on "python-setuptools" => [:build, :test]
  depends_on "python@3.10" => [:build, :test]
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]

  def pythons
    deps.map(&:to_formula)
        .select { |f| f.name.match?(/^python@\d\.\d+$/) }
        .sort_by(&:version)
        .map { |f| f.opt_libexec/"bin/python" }
  end

  def install
    pythons.each do |python|
      system python, "-m", "pip", "install", *std_pip_args(prefix: libexec), "."
    end
  end

  test do
    phrase = "You are using Homebrew"
    (testpath/"package_manager.pyx").write "print '#{phrase}'"
    (testpath/"setup.py").write <<~EOS
      from setuptools import setup
      from Cython.Build import cythonize

      setup(
        ext_modules = cythonize("package_manager.pyx")
      )
    EOS
    pythons.each do |python|
      with_env(PYTHONPATH: libexec/Language::Python.site_packages(python)) do
        system python, "setup.py", "build_ext", "--inplace"
        assert_match phrase, shell_output("#{python} -c 'import package_manager'")
      end
    end
  end
end