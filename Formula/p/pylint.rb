class Pylint < Formula
  include Language::Python::Virtualenv

  desc "It's not just a linter that annoys you!"
  homepage "https://pylint.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/19/3c/be4bb2d62e3d1bee3f3aa14af5b294813ad53351cacb3b03fbaf3f851e03/pylint-4.1.2.tar.gz"
  sha256 "235f13dc418c0041c649b42a5c35c99f2ffc6ca8b6a7574958eac5335906a68a"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0b429a8515812bf82f1ed15d7048a91e82b037a088e9432cd05ffd5f51ae0407"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0b429a8515812bf82f1ed15d7048a91e82b037a088e9432cd05ffd5f51ae0407"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0b429a8515812bf82f1ed15d7048a91e82b037a088e9432cd05ffd5f51ae0407"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "418d154cbdf7b47388d0d03cf98abbbb2162e78457228c66d970af58b3573ad5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "418d154cbdf7b47388d0d03cf98abbbb2162e78457228c66d970af58b3573ad5"
  end

  depends_on "rust" => :build # for `isort`
  depends_on "python@3.14"

  resource "astroid" do
    url "https://files.pythonhosted.org/packages/8d/7e/7c85d2b8549730e089bd984678a7efb64c510a5f09b4f0d9987a8354a80c/astroid-4.3.3.tar.gz"
    sha256 "d03854b09d92c08e18d8e7d9185d393961186ed0747136d8fcb2d1c008a504ec"
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