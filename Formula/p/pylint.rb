class Pylint < Formula
  include Language::Python::Virtualenv

  desc "It's not just a linter that annoys you!"
  homepage "https://pylint.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/7a/ae/e1732157f8b6418532a1a2a733068c5c1ca62790ff8cc320433d2523682e/pylint-4.1.1.tar.gz"
  sha256 "47538540de0a563ff0b6cb781330944b0c9c1a130986ad1c183116ed37ec4538"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8364112b4c9f950fe3defa9e6fdf4a543d7edce837ce62c748b8a6d3f6b800e8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8364112b4c9f950fe3defa9e6fdf4a543d7edce837ce62c748b8a6d3f6b800e8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8364112b4c9f950fe3defa9e6fdf4a543d7edce837ce62c748b8a6d3f6b800e8"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "78bc7055589d7552c18222aea12b201341b196af9b22f1b1f4a93bcf5b0db67f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "78bc7055589d7552c18222aea12b201341b196af9b22f1b1f4a93bcf5b0db67f"
  end

  depends_on "rust" => :build # for `isort`
  depends_on "python@3.14"

  resource "astroid" do
    url "https://files.pythonhosted.org/packages/61/be/ae2dbb9687591b236dfa45113812c8b9616f4a49318ec4ca6dc927fdf21f/astroid-4.3.2.tar.gz"
    sha256 "8cdaf5b7f3f4f39557ae05ed8b0852136b43a04ab686db7d39255b206233677a"
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
    url "https://files.pythonhosted.org/packages/17/c8/721b3855fe457da514fe249247d404b9b39c5d16532278f70ebaa6acf18b/platformdirs-4.12.2.tar.gz"
    sha256 "eab5f70271a490ef74618bb314fbb86e3c7e82fa3b9c922c2ea0e0a1a155d329"
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