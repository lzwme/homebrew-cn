class Libcython < Formula
  desc "Compiler for writing C extensions for the Python language"
  homepage "https://cython.org/"
  url "https://files.pythonhosted.org/packages/23/e9/ef8607abfbbbaeb93cb1381c8538a22d38d64524df39759dc2787d4909b0/Cython-3.0.7.tar.gz"
  sha256 "fb299acf3a578573c190c858d49e0cf9d75f4bc49c3f24c5a63804997ef09213"
  license "Apache-2.0"

  livecheck do
    formula "cython"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3e3358e0b4266d16b48bd1ee18c927ca7aed935f4f6fd5ea3d670ce55d7bc2f8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dbfd3aaaa855f5332f1f5f9cf94be365560bb17e22c8a961dc5ec4026edf707e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ade01df593112edbfb7d27f8ef8ef618596aca279d14a88c9a3c86d105c1a137"
    sha256 cellar: :any_skip_relocation, sonoma:         "ed9467a17fdcd5ba21649ee1d93e30159d9c970a451b4b6bdd22cf223c7f746e"
    sha256 cellar: :any_skip_relocation, ventura:        "742b41a1d3fd39ca0de881f732a38a095c33e844ea7824bbc93493af393ac599"
    sha256 cellar: :any_skip_relocation, monterey:       "cdf0d9692a407fff5cd3426218cb6b6cc8dc0b199b2d2b99ad0f36b5c58c7a09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0e53a6d15ef52dfda8f1d8f407a7c9bd2b96cae66cef90d161e546bd747acc65"
  end

  keg_only <<~EOS
    this formula is mainly used internally by other formulae.
    Users are advised to use `pip` to install cython
  EOS

  depends_on "python-setuptools" => [:build, :test]
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