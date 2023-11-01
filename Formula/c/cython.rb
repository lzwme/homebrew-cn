class Cython < Formula
  desc "Compiler for writing C extensions for the Python language"
  homepage "https://cython.org/"
  url "https://files.pythonhosted.org/packages/16/fb/82178bc16887eb9b03f2fc73c50aaa96ce528c3fd3c6f89cae631923af15/Cython-3.0.5.tar.gz"
  sha256 "39318348db488a2f24e7c84e08bdc82f2624853c0fea8b475ea0b70b27176492"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "67d4231cdb917c60336abc8b9870da497607f6b215435c8d1d6b2eaee0e2f2e0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "606edec1e5f6c9b8dc025f20b7834cae4686327d07c792a8d5e1a4fa027fe424"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cbf8ae7c1f613f19facaecc5baad7af5c4c880d8c191ab4312dab253a023bfe3"
    sha256 cellar: :any_skip_relocation, sonoma:         "faff053a15a76da41528f9ee1bf307cd2e3f5a84ea35f3317a119123ed2caaf7"
    sha256 cellar: :any_skip_relocation, ventura:        "089259b6205ce35c69c9d3d61b3fefe2fd5fa5eeeea50220282f6fea6d06653e"
    sha256 cellar: :any_skip_relocation, monterey:       "d4765d2173977c5bbc6b4f49faf60541a85f4b2ea497b5a78b9b61f632487970"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cf9b224e592de0521c87028a28894f97e45f2df48447f7ad3de069241ee1f4bb"
  end

  keg_only <<~EOS
    this formula is mainly used internally by other formulae.
    Users are advised to use `pip` to install cython
  EOS

  depends_on "python@3.11"

  def python3
    "python3.11"
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