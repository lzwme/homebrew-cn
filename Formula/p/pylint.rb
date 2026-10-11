class Pylint < Formula
  include Language::Python::Virtualenv

  desc "It's not just a linter that annoys you!"
  homepage "https://pylint.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/19/3c/be4bb2d62e3d1bee3f3aa14af5b294813ad53351cacb3b03fbaf3f851e03/pylint-4.1.2.tar.gz"
  sha256 "235f13dc418c0041c649b42a5c35c99f2ffc6ca8b6a7574958eac5335906a68a"
  license "GPL-2.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "41c05ebf227140fe71d81bb992f66b47f506c83cd27d458767e43eaabad178c3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "41c05ebf227140fe71d81bb992f66b47f506c83cd27d458767e43eaabad178c3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "41c05ebf227140fe71d81bb992f66b47f506c83cd27d458767e43eaabad178c3"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "465cf70cd6a6569789b167ff1ee79436c77f5618e5b4e94f25d61c24bad40449"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "465cf70cd6a6569789b167ff1ee79436c77f5618e5b4e94f25d61c24bad40449"
  end

  depends_on "rust" => :build # for `isort`
  depends_on "python@3.15"

  resource "astroid" do
    url "https://files.pythonhosted.org/packages/2d/87/5732fa68bf100a095cfcbd108f919220d995db99e1a7502b8119a869fd62/astroid-4.3.4.tar.gz"
    sha256 "d515a105722b72098bbe82d430d65e635f742b6cbac3bdfaf8b7c188b87c5e39"
  end

  resource "dill" do
    url "https://files.pythonhosted.org/packages/81/e1/56027a71e31b02ddc53c7d65b01e68edf64dea2932122fe7746a516f75d5/dill-0.4.1.tar.gz"
    sha256 "423092df4182177d4d8ba8290c8a5b640c66ab35ec7da59ccfa00f6fa3eea5fa"
  end

  resource "isort" do
    url "https://files.pythonhosted.org/packages/da/cf/068066b8fdab91cd40bcd63e483137908710a3d25a4d3a01b538be45d9d6/isort-9.0.2.tar.gz"
    sha256 "d2298980ce44350f11d9d24c8150eaef1883431ec203dddbb4e9b5c3ceb54c70"
  end

  resource "mccabe" do
    url "https://files.pythonhosted.org/packages/e7/ff/0ffefdcac38932a54d2b5eed4e0ba8a408f215002cd178ad1df0f2806ff8/mccabe-0.7.0.tar.gz"
    sha256 "348e0240c33b60bbdf4e523192ef919f28cb2c3d7d5c7794f74009290f236325"
  end

  resource "mypy-extensions" do
    url "https://files.pythonhosted.org/packages/a2/6e/371856a3fb9d31ca8dac321cda606860fa4548858c0cc45d9d1d4ca2628b/mypy_extensions-1.1.0.tar.gz"
    sha256 "52e68efc3284861e772bbcd66823fde5ae21fd2fdb51c62a211403730b916558"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/90/a1/d5f9002a70298c64a789779077d8dd90c10aa1f47fe40c86802df874f2a6/platformdirs-4.12.4.tar.gz"
    sha256 "63743c02414e755de4e31b8f68125c1407495b86c5a006e203c01ff8b9924250"
  end

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/94/96/e07752635b98536177fa1f37671c8f3cdde2e724c6bcf6034b2cfb571565/tomlkit-0.15.1.tar.gz"
    sha256 "e25bbf38843005246210a12982776f27f99cb9be67160e14434d0c0d21ee1e97"
  end

  def install
    virtualenv_install_with_resources

    inreplace libexec/"pyvenv.cfg", HOMEBREW_PREFIX, prefix
  end

  test do
    (testpath/"pylint_test.py").write <<~PYTHON
      print('Test file'
      )
    PYTHON
    system bin/"pylint", "--exit-zero", "pylint_test.py"
  end
end