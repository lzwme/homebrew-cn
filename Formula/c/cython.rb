class Cython < Formula
  desc "Compiler for writing C extensions for the Python language"
  homepage "https://cython.org/"
  url "https://files.pythonhosted.org/packages/41/eb/416c7f3060a714646a91499822ffac4767ecca6f005d48ef9cef4da10175/Cython-3.0.1.tar.gz"
  sha256 "f3e49c4eaaa11345486ac0fa2b350636e44a4b45bd7521a6b133924c5ff20bba"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f37849301caef844e913c1737e4d5b5bbc4290a4c05b0e4aac6da8c8a9b30356"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bd8aeb7c28152c41302e91716e8ed4ce8301523763facaebacc9e6d6b4850bf8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "edb2bf5dc4aafc81bded11692de9390bc4022f9d3a32c4ca622d0fbc0f3b3f8e"
    sha256 cellar: :any_skip_relocation, ventura:        "4d3033b0369c8d140686c1d36d1cd5f562195532334d30a7fb149dab85537d32"
    sha256 cellar: :any_skip_relocation, monterey:       "4d1a3faf691e6f9a01ab6c4214b3f55ccebfc478456d031cfeb6cf45ece3419e"
    sha256 cellar: :any_skip_relocation, big_sur:        "b57122d339ab37e06e910b827e9acfc08eb3c5fddeebd93ae01b8e027f0fcb3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1cee3e2ab00dacbdb6d8c4ced6f2ad5ea0646cf5cac0df3ad2dda92c2c8624ef"
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