class Cython < Formula
  desc "Compiler for writing C extensions for the Python language"
  homepage "https://cython.org/"
  url "https://files.pythonhosted.org/packages/16/fb/82178bc16887eb9b03f2fc73c50aaa96ce528c3fd3c6f89cae631923af15/Cython-3.0.5.tar.gz"
  sha256 "39318348db488a2f24e7c84e08bdc82f2624853c0fea8b475ea0b70b27176492"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1b8560892dd2869a8ec8906236d8d27f979deba4330386501fdb559d0e608ca8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d01fb2ad9de34cf2be44cd7576cd8f9e9f91e347392da3e36fb180082d8bbb12"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a89997e9e1acc778e8e29c4de0196042f10a2ef7917deeb836f1a294981dc3d5"
    sha256 cellar: :any_skip_relocation, sonoma:         "ce33d0a63f399646fcd47c82a2c78a7e2574e9f5e0b603d8668e80e7111047d5"
    sha256 cellar: :any_skip_relocation, ventura:        "636c86a24eb19afa93e60cb57b779573b5fda9bde7569e0e882da6acca0b022e"
    sha256 cellar: :any_skip_relocation, monterey:       "8db439afcd38218a2784d36efc4c19c0d95d52e14dff0ed8227b12da085f65fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "36389d385f776ee8c853e728f8e546ce33230483a85117a2b02c517508d58357"
  end

  keg_only <<~EOS
    this formula is mainly used internally by other formulae.
    Users are advised to use `pip` to install cython
  EOS

  depends_on "python-setuptools" => [:build, :test]
  depends_on "python@3.12"

  def python3
    "python3.12"
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
    (testpath/"setup.py").write <<~EOS
      from distutils.core import setup
      from Cython.Build import cythonize

      setup(
        ext_modules = cythonize("package_manager.pyx")
      )
    EOS
    system python3, "setup.py", "build_ext", "--inplace"
    assert_match phrase, shell_output("#{python3} -c 'import package_manager'")
  end
end