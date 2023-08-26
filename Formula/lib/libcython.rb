class Libcython < Formula
  desc "Compiler for writing C extensions for the Python language"
  homepage "https://cython.org/"
  url "https://files.pythonhosted.org/packages/41/eb/416c7f3060a714646a91499822ffac4767ecca6f005d48ef9cef4da10175/Cython-3.0.1.tar.gz"
  sha256 "f3e49c4eaaa11345486ac0fa2b350636e44a4b45bd7521a6b133924c5ff20bba"
  license "Apache-2.0"

  livecheck do
    formula "cython"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "918e512958cd62868f688d4efcc6e96fbcff2fed9db4773a4a42de94873676db"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cdc4212ee104ccc758b2b8722f6b855123dc0224b6a2e1fcaefb96da81efe111"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6397e386559c27ed07fd12ee76330a0ff2c2822ea622eb05ffdc302d2cbc5a59"
    sha256 cellar: :any_skip_relocation, ventura:        "b0c3e68f108a1bc50c455d9d417c4348831ca87e3fe58fb274245ec26afd2bf5"
    sha256 cellar: :any_skip_relocation, monterey:       "c66234cbc139ee75f21b4b0fe6a17253578ec5e0e6b312fc031c2c11f1eef01a"
    sha256 cellar: :any_skip_relocation, big_sur:        "86a899aeb24d29917ffcce06fc8326c8f8728c6869042d047602703c6ebee68a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c85ed2ba3689093b98b1e3ed757958cafdcf3e208b352cd575d42272bdeb3859"
  end

  keg_only <<~EOS
    this formula is mainly used internally by other formulae.
    Users are advised to use `pip` to install cython
  EOS

  depends_on "python@3.10" => [:build, :test]
  depends_on "python@3.11" => [:build, :test]

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
      from distutils.core import setup
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