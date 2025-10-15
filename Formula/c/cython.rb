class Cython < Formula
  desc "Compiler for writing C extensions for the Python language"
  homepage "https://cython.org/"
  url "https://files.pythonhosted.org/packages/a7/f6/d762df1f436a0618455d37f4e4c4872a7cd0dcfc8dec3022ee99e4389c69/cython-3.1.4.tar.gz"
  sha256 "9aefefe831331e2d66ab31799814eae4d0f8a2d246cbaaaa14d1be29ef777683"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b6520538e3f78ff3b1da24a2cb1576f02c0b4bd582a76aab3932ec050e4b3520"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fd1b246613a2ae5dd2f33c376a069795179149935f10ee141484ff47995877bf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "31c247aed8fe5fee90e9701db87865b9411d515306e819c936956ca13397cf3b"
    sha256 cellar: :any_skip_relocation, sonoma:        "f8608af7653e550d63d5ca0a5e0dac40ccc8a7d11f38f20fe272f0bd4263ec1d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "92f59446dd10ca529903c2f668c9294638b3a8103047f9c2bf1022df76462d7c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6e9dc4da4feb88a9eec5dfe0f147e4c32d979a9e2585de30842bfd5724dcdc0d"
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