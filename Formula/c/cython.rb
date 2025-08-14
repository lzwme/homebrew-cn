class Cython < Formula
  desc "Compiler for writing C extensions for the Python language"
  homepage "https://cython.org/"
  url "https://files.pythonhosted.org/packages/18/ab/915337fb39ab4f4539a313df38fc69938df3bf14141b90d61dfd5c2919de/cython-3.1.3.tar.gz"
  sha256 "10ee785e42328924b78f75a74f66a813cb956b4a9bc91c44816d089d5934c089"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "158d41701bbe6894639845b05e3374aac4a720c78a6fb8ef6a40301a665a6d8d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3167db3ea47a59734af4da5d3df42166e8690dc8cd48a4ff0fbf19430b117a08"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9f1a6a5bc07bfd0ab14b43f7760c7a53e586cfa90ad992a9d25432075a965b38"
    sha256 cellar: :any_skip_relocation, sonoma:        "5fc68d238b388fa9c9705f4810b8f255f5554fc63d49a5b43c68f098f57d42a5"
    sha256 cellar: :any_skip_relocation, ventura:       "969a2690ab7e877d84dc610383dc2d48fa44d6abfc0ded547bc834296bc2b819"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c59ff2620fafbcea75d421331f9826991dc3f6a7bac4fa441c62e26740b99ab9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fa7e8449c996e8102e7c5f0c02f09cf1890b5a97e2d2047361d48e2fac9c968e"
  end

  keg_only <<~EOS
    this formula is mainly used internally by other formulae.
    Users are advised to use `pip` to install cython
  EOS

  depends_on "python-setuptools" => [:build, :test]
  depends_on "python@3.13"

  def python3
    "python3.13"
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