class Cython < Formula
  desc "Compiler for writing C extensions for the Python language"
  homepage "https://cython.org/"
  url "https://files.pythonhosted.org/packages/23/e9/ef8607abfbbbaeb93cb1381c8538a22d38d64524df39759dc2787d4909b0/Cython-3.0.7.tar.gz"
  sha256 "fb299acf3a578573c190c858d49e0cf9d75f4bc49c3f24c5a63804997ef09213"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "15bc1bdecd4946f8e6b31ffe2bcbba8ca252e452350b3cfb4adb876ba4f0ac17"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f7689807e1002fd0e93345ac64b44da0afc0e9850c3d4bfa0d27cabcf09c0644"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "45709649b2c6ef9a07264521cb8ef24a7322cf335d12e1beaa9f806b645c1f55"
    sha256 cellar: :any_skip_relocation, sonoma:         "97451ba3f0a3ecb7e8d93cb66b1a695ae35c6af72a28d075d30aba0e0629a4aa"
    sha256 cellar: :any_skip_relocation, ventura:        "00a266fa3da600add1ac922ff3367febb362726763ab16fcf734c56d822cb864"
    sha256 cellar: :any_skip_relocation, monterey:       "2123eba492a82e7ec83d7dfb31a964d793852ab0b9d6b371920581f510c56dda"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4fba39b26c531a7f9cdcb369cc025897fd6cac068be41647c0c096f18637d479"
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