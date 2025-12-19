class Virtualenv < Formula
  include Language::Python::Virtualenv

  desc "Tool for creating isolated virtual python environments"
  homepage "https://virtualenv.pypa.io/"
  url "https://files.pythonhosted.org/packages/20/28/e6f1a6f655d620846bd9df527390ecc26b3805a0c5989048c210e22c5ca9/virtualenv-20.35.4.tar.gz"
  sha256 "643d3914d73d3eeb0c552cbb12d7e82adf0e504dbf86a3182f8771a153a1971c"
  license "MIT"
  revision 1
  head "https://github.com/pypa/virtualenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7853202ea16d598b008c6f0ad7e584eb67aa7b93484359f90f9d69c35c3efcc4"
  end

  depends_on "python@3.14"

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/96/8e/709914eb2b5749865801041647dc7f4e6d00b549cfe88b65ca192995f07c/distlib-0.4.0.tar.gz"
    sha256 "feec40075be03a04501a973d81f633735b4b69f98b05450592310c0f401a4e0d"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/a7/23/ce7a1126827cedeb958fc043d61745754464eb56c5937c35bbf2b8e26f34/filelock-3.20.1.tar.gz"
    sha256 "b8360948b351b80f420878d8516519a2204b07aefcdcfd24912a5d33127f188c"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/cf/86/0248f086a84f01b37aaec0fa567b397df1a119f73c16f6c7a9aac73ea309/platformdirs-4.5.1.tar.gz"
    sha256 "61d5cdcc6065745cdd94f0f878977f8de9437be93de97c1c12f853c9c0cdcbda"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"virtualenv", "venv_dir"
    assert_match "venv_dir", shell_output("venv_dir/bin/python -c 'import sys; print(sys.prefix)'")
  end
end