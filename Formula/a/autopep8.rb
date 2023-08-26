class Autopep8 < Formula
  include Language::Python::Virtualenv

  desc "Automatically formats Python code to conform to the PEP 8 style guide"
  homepage "https://github.com/hhatto/autopep8"
  url "https://files.pythonhosted.org/packages/05/e9/f42b5233dc0d68c747d3dfc03ef191f3935211f9dedf66fa94e8ea9ac58f/autopep8-2.0.3.tar.gz"
  sha256 "ba4901621c7f94c6fce134437d577009886d5e3bfa46ee64e1d1d864a5b93cc2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f3ce007a85b838db399b9167314beb7211f5ee30da359ff9ca8378b1c2d38764"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "48e49e1c1bfa25caa7aa2966b0b33a324bf209e16c8c413bc449e479339d1c50"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5da9805272a28694edb64c77cb8cf64f63122d630978679ffb40743c8071c091"
    sha256 cellar: :any_skip_relocation, ventura:        "03ca99c82e9994a214b54c1c65bd6fba8847b4d164d3f69c12dfc17f7d9fccdf"
    sha256 cellar: :any_skip_relocation, monterey:       "db46bcdec6bed1ac12f07402d942355e82d447cc8dd0a8eeb48ffd12a7611a92"
    sha256 cellar: :any_skip_relocation, big_sur:        "4be9b05b14a2fb72461b1accf244cda09ffa3d72e091c0990796f084a7dd1137"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c9e6ed4d02e21f935a2848c35674e777ce68200e046863bff20573f87974fa2b"
  end

  depends_on "python@3.11"

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/b9/6c/7c6658d258d7971c5eb0d9b69fa9265879ec9a9158031206d47800ae2213/packaging-23.1.tar.gz"
    sha256 "a392980d2b6cffa644431898be54b0045151319d1e7ec34f0cfed48767dd334f"
  end

  resource "pycodestyle" do
    url "https://ghproxy.com/https://github.com/PyCQA/pycodestyle/archive/2.11.0.tar.gz"
    sha256 "757a3dba55dce2ae8b01fe7b46c20cd1e4c0fe794fe6119bce66b942f35e2db0"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = pipe_output("#{bin}/autopep8 -", "x='homebrew'")
    assert_equal "x = 'homebrew'", output.strip
  end
end