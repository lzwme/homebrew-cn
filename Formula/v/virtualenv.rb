class Virtualenv < Formula
  include Language::Python::Virtualenv

  desc "Tool for creating isolated virtual python environments"
  homepage "https://virtualenv.pypa.io/"
  url "https://files.pythonhosted.org/packages/1c/14/37fcdba2808a6c615681cd216fecae00413c9dab44fb2e57805ecf3eaee3/virtualenv-20.34.0.tar.gz"
  sha256 "44815b2c9dee7ed86e387b842a84f20b93f7f417f95886ca1996a72a4138eb1a"
  license "MIT"
  head "https://github.com/pypa/virtualenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "48a41a671bc8ca3c96943bbd7a6943490ede43b3393b259451df9c5530cab94f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "48a41a671bc8ca3c96943bbd7a6943490ede43b3393b259451df9c5530cab94f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "48a41a671bc8ca3c96943bbd7a6943490ede43b3393b259451df9c5530cab94f"
    sha256 cellar: :any_skip_relocation, sonoma:        "3c4162a8a9c5d484d8275915a87b0e4a3af7521ad5febd95d1965d6fa5f06ed3"
    sha256 cellar: :any_skip_relocation, ventura:       "3c4162a8a9c5d484d8275915a87b0e4a3af7521ad5febd95d1965d6fa5f06ed3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3c4162a8a9c5d484d8275915a87b0e4a3af7521ad5febd95d1965d6fa5f06ed3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3c4162a8a9c5d484d8275915a87b0e4a3af7521ad5febd95d1965d6fa5f06ed3"
  end

  depends_on "python@3.13"

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/96/8e/709914eb2b5749865801041647dc7f4e6d00b549cfe88b65ca192995f07c/distlib-0.4.0.tar.gz"
    sha256 "feec40075be03a04501a973d81f633735b4b69f98b05450592310c0f401a4e0d"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/0a/10/c23352565a6544bdc5353e0b15fc1c563352101f30e24bf500207a54df9a/filelock-3.18.0.tar.gz"
    sha256 "adbc88eabb99d2fec8c9c1b229b171f18afa655400173ddc653d5d01501fb9f2"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/fe/8b/3c73abc9c759ecd3f1f7ceff6685840859e8070c4d947c93fae71f6a0bf2/platformdirs-4.3.8.tar.gz"
    sha256 "3d512d96e16bcb959a814c9f348431070822a6496326a4be0911c40b5a74c2bc"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"virtualenv", "venv_dir"
    assert_match "venv_dir", shell_output("venv_dir/bin/python -c 'import sys; print(sys.prefix)'")
  end
end