class Cython < Formula
  desc "Compiler for writing C extensions for the Python language"
  homepage "https://cython.org/"
  url "https://files.pythonhosted.org/packages/d3/20/02f4961b4315b95989abfe4b7cedff263cc89693834222d210a7a62a6214/Cython-3.0.6.tar.gz"
  sha256 "399d185672c667b26eabbdca420c98564583798af3bc47670a8a09e9f19dd660"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3fa45ba4e99a2e5460842965ed0578a8373d5dac6b89a6c132d8f83ea1b50552"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8b88e192f8076487bda1b1b48569ed9f043f10657bbba837e80af3319ce445a9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e656c31b93a3abf9931c61d3da071ee10e4fa69db42337b2946770a38f6e00b8"
    sha256 cellar: :any_skip_relocation, sonoma:         "7ae18a8273c008d82af3ccd92b20c4e8fb8d69fdd53bc6c7150e68bc6d42b1b9"
    sha256 cellar: :any_skip_relocation, ventura:        "53d551b62c2f028265be1ed99a7a1140352826dbe67a2fdbd640b20f9cc53b09"
    sha256 cellar: :any_skip_relocation, monterey:       "9b7b3d2892fdcc7754299668f8b14c3a47dc1145b0349b338dacb0dae6c0f305"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "59019f1c1c835919aaa5b962e13f4d343652e352852dc192f36a71f31189dc63"
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