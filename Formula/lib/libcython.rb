class Libcython < Formula
  desc "Compiler for writing C extensions for the Python language"
  homepage "https://cython.org/"
  url "https://files.pythonhosted.org/packages/16/fb/82178bc16887eb9b03f2fc73c50aaa96ce528c3fd3c6f89cae631923af15/Cython-3.0.5.tar.gz"
  sha256 "39318348db488a2f24e7c84e08bdc82f2624853c0fea8b475ea0b70b27176492"
  license "Apache-2.0"

  livecheck do
    formula "cython"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3a252c98a646352d3799ad74baa66ee03220f308c20c8a8be948a0521ea27232"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3aa24630c41115a52f20423ebf063cee83eb400e02369dae35eac1c38b67e940"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a4752c7f310a367f98432358b301e33706717083a13ba845c32e13db3efd82e2"
    sha256 cellar: :any_skip_relocation, sonoma:         "f8ebc729d440bc3e08ff5afd58262fdb47f334ff2cd546d4eb8dd16e6dabfadf"
    sha256 cellar: :any_skip_relocation, ventura:        "3d1e90da2e48011cd4c39e6663f14c1d5d22175c81e3c2389e69b8e169842dc6"
    sha256 cellar: :any_skip_relocation, monterey:       "78c663d1467266278bbf3554986b5f7a11e56311ec19a2b53d083ded06fe9d93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "160c010411f3e26d939eb20618afdce7619def64dab496061fc438ac1e0c4e7d"
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