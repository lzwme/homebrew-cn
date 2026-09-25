class Pylint < Formula
  include Language::Python::Virtualenv

  desc "It's not just a linter that annoys you!"
  homepage "https://pylint.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/e0/5e/d5ec2c861010cf8577a3e5baaf2405fdf1004f1657d9245c4efb006c1dfd/pylint-4.0.9.tar.gz"
  sha256 "6f1305780229ae720e89b8aff2b3ff857cbb268fbab98c8b586960267667ad34"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "662402bfb0903063a14de87638e3d265d11a96b3686dd19ce8a449fd06bbf544"
  end

  depends_on "rust" => :build # for `isort`
  depends_on "python@3.14"

  resource "astroid" do
    url "https://files.pythonhosted.org/packages/07/63/0adf26577da5eff6eb7a177876c1cfa213856be9926a000f65c4add9692b/astroid-4.0.4.tar.gz"
    sha256 "986fed8bcf79fb82c78b18a53352a0b287a73817d6dbcfba3162da36667c49a0"
  end

  resource "dill" do
    url "https://files.pythonhosted.org/packages/81/e1/56027a71e31b02ddc53c7d65b01e68edf64dea2932122fe7746a516f75d5/dill-0.4.1.tar.gz"
    sha256 "423092df4182177d4d8ba8290c8a5b640c66ab35ec7da59ccfa00f6fa3eea5fa"
  end

  resource "isort" do
    url "https://files.pythonhosted.org/packages/e6/43/067e17bfa10b6486b408d5294105ac894149a9abb94b338568b1f53a73c9/isort-9.0.1.tar.gz"
    sha256 "ba23db109e3e93ef1999f7209a651214994cd807801addd16ac485982eb4edd7"
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
    url "https://files.pythonhosted.org/packages/ea/dd/65804b0c2925a1c821a05502ea57517b69a073ff400d25ab9faa3a2cf012/platformdirs-4.11.12.tar.gz"
    sha256 "e8dc1cb58f1153fd7f61db1374317770baababec2480b37b8f01c6cc25b45267"
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