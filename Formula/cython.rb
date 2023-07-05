class Cython < Formula
  desc "Compiler for writing C extensions for the Python language"
  homepage "https://cython.org/"
  url "https://files.pythonhosted.org/packages/38/db/df0e99d6c5fe19ee5c981d22aad557be4bdeed3ecfae25d47b84b07f0f98/Cython-0.29.36.tar.gz"
  sha256 "41c0cfd2d754e383c9eeb95effc9aa4ab847d0c9747077ddd7c0dcb68c3bc01f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "35e1f19c7c652c9b9e58fe14e48e634eb7e09f0342bc4ad5b08f2a1334b43f9e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4abbab9a2690088e900c4e9374850aad95d1836a5eb4150fb390f152a3fa6da3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8e8c31771d7ed1d261cd561080e3dc6e9175ec878889d64529b31ea06cb3e9ef"
    sha256 cellar: :any_skip_relocation, ventura:        "8d2cb0395d72faef51aaa68cb45dc2503300192947f0a7851a34fda9fb920af0"
    sha256 cellar: :any_skip_relocation, monterey:       "f289715fb8a3fc2f51f94086fa318725147c2ba3e9ba003e5a6f20dc49aa4b94"
    sha256 cellar: :any_skip_relocation, big_sur:        "15063e43fc5b04afc05eef17cfd0a0b1b187f05f3710ca44e779e22727afa054"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4858951a1fbbd9f92255b6ac4aaf771c8479051d9aaccbda346cae68b282e7bf"
  end

  keg_only <<~EOS
    this formula is mainly used internally by other formulae.
    Users are advised to use `pip` to install cython
  EOS

  depends_on "python@3.11"

  def install
    python = "python3.11"
    ENV.prepend_create_path "PYTHONPATH", libexec/Language::Python.site_packages(python)
    system python, *Language::Python.setup_install_args(libexec, python)

    bin.install (libexec/"bin").children
    bin.env_script_all_files(libexec/"bin", PYTHONPATH: ENV["PYTHONPATH"])
  end

  test do
    python = Formula["python@3.11"].opt_bin/"python3.11"
    ENV.prepend_path "PYTHONPATH", libexec/Language::Python.site_packages(python)

    phrase = "You are using Homebrew"
    (testpath/"package_manager.pyx").write "print '#{phrase}'"
    (testpath/"setup.py").write <<~EOS
      from distutils.core import setup
      from Cython.Build import cythonize

      setup(
        ext_modules = cythonize("package_manager.pyx")
      )
    EOS
    system python, "setup.py", "build_ext", "--inplace"
    assert_match phrase, shell_output("#{python} -c 'import package_manager'")
  end
end