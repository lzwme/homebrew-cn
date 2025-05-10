class Cython < Formula
  desc "Compiler for writing C extensions for the Python language"
  homepage "https://cython.org/"
  url "https://files.pythonhosted.org/packages/cf/f7/db37a613aec5abcd51c8000a386a701ac32e94659aa03fa69c3e5c19b149/cython-3.1.0.tar.gz"
  sha256 "1097dd60d43ad0fff614a57524bfd531b35c13a907d13bee2cc2ec152e6bf4a1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "523ef2906c0a49f7b8f6bd42cdc590c88cbd8f2e23fd3103ab7639831d006a40"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ba69d65522aaac7020b293bbee17f8bb7f94f3cba2d4fbe2a2fd2410b13da7e0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1ead5f57ce8703c3a5f849de31f5de4b95282db40a3d4d9f9f97b52e09caab9d"
    sha256 cellar: :any_skip_relocation, sonoma:        "f138b2d41d2fe40dba1e18748c362dff2e11f64c6735df7c5a7208f631660689"
    sha256 cellar: :any_skip_relocation, ventura:       "fd1b184b73148ce28997af38e4090adb1a85d1f724fefc8181fb77c32cf76d46"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7cc0e4a4e1dc5ba4039b8ae2ac033e57327d004d8dc9272a8f234ef248b2f799"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1359e72e9f13a895116e7cd58659ca0c03ed92eec6b2fedad0d4f17604d0d3d3"
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