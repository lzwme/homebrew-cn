class Snakefmt < Formula
  include Language::Python::Virtualenv

  desc "Snakemake code formatter"
  homepage "https://github.com/snakemake/snakefmt/"
  url "https://files.pythonhosted.org/packages/1f/73/01accd8e2ff05ed144c3140e56371e110cc63dc4c44694d9399e0f746eef/snakefmt-0.11.3.tar.gz"
  sha256 "3efb82f66c0597712126ad540ec15cee24d797e443894fd86ccf6aa907506ec0"
  license "MIT"
  head "https://github.com/snakemake/snakefmt.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1bb951cd913160a8af9ad32b0a30b6e87f492a7eb0ecd389a52be09553a8b9ee"
  end

  depends_on "python@3.14"

  resource "black" do
    url "https://files.pythonhosted.org/packages/d8/0d/cc2fb42b8c50d80143221515dd7e4766995bd07c56c9a3ed30baf080b6dc/black-24.10.0.tar.gz"
    sha256 "846ea64c97afe3bc677b761787993be4991810ecc7a4a937816dd6bddedc4875"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/3d/fa/656b739db8587d7b5dfa22e22ed02566950fbfbcdc20311993483657a5c0/click-8.3.1.tar.gz"
    sha256 "12ff4785d337a1bb490bb7e9c2b1ee5da3112e94a8622f26a6c77f5d2fc6842a"
  end

  resource "mypy-extensions" do
    url "https://files.pythonhosted.org/packages/a2/6e/371856a3fb9d31ca8dac321cda606860fa4548858c0cc45d9d1d4ca2628b/mypy_extensions-1.1.0.tar.gz"
    sha256 "52e68efc3284861e772bbcd66823fde5ae21fd2fdb51c62a211403730b916558"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/65/ee/299d360cdc32edc7d2cf530f3accf79c4fca01e96ffc950d8a52213bd8e4/packaging-26.0.tar.gz"
    sha256 "00243ae351a257117b6a241061796684b084ed1c516a08c48a3f7e147a9d80b4"
  end

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/4c/b2/bb8e495d5262bfec41ab5cb18f522f1012933347fb5d9e62452d446baca2/pathspec-1.0.3.tar.gz"
    sha256 "bac5cf97ae2c2876e2d25ebb15078eb04d76e4b98921ee31c6f85ade8b59444d"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/cf/86/0248f086a84f01b37aaec0fa567b397df1a119f73c16f6c7a9aac73ea309/platformdirs-4.5.1.tar.gz"
    sha256 "61d5cdcc6065745cdd94f0f878977f8de9437be93de97c1c12f853c9c0cdcbda"
  end

  def install
    # hatch does not support a SOURCE_DATE_EPOCH before 1980.
    # Remove after https://github.com/pypa/hatch/pull/1999 is released.
    ENV["SOURCE_DATE_EPOCH"] = "1451574000"

    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"snakefmt", shell_parameter_format: :click)
  end

  test do
    test_file = testpath/"Snakefile"
    test_file.write <<~EOS
      rule testme:
          output:
               "test.out"
          shell:
               "touch {output}"
    EOS
    test_output = shell_output("#{bin}/snakefmt --check #{test_file} 2>&1", 1)
    assert_match "[INFO] 1 file(s) would be changed 😬", test_output

    assert_match "snakefmt, version #{version}",
      shell_output("#{bin}/snakefmt --version")
  end
end