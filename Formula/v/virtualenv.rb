class Virtualenv < Formula
  include Language::Python::Virtualenv

  desc "Tool for creating isolated virtual python environments"
  homepage "https://virtualenv.pypa.io/"
  url "https://files.pythonhosted.org/packages/8b/60/4f20960df6c7b363a18a55ab034c8f2bcd5d9770d1f94f9370ec104c1855/virtualenv-20.33.1.tar.gz"
  sha256 "1b44478d9e261b3fb8baa5e74a0ca3bc0e05f21aa36167bf9cbf850e542765b8"
  license "MIT"
  head "https://github.com/pypa/virtualenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0835bd9e7533f158fb74e39fc3d9e3d1abf418b42f411d9f8d6e535f94d60e80"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0835bd9e7533f158fb74e39fc3d9e3d1abf418b42f411d9f8d6e535f94d60e80"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0835bd9e7533f158fb74e39fc3d9e3d1abf418b42f411d9f8d6e535f94d60e80"
    sha256 cellar: :any_skip_relocation, sonoma:        "18d2a0244cb3cfd13eed9864dfc5c4582624c1bfbd5725d81e622b84101d8797"
    sha256 cellar: :any_skip_relocation, ventura:       "18d2a0244cb3cfd13eed9864dfc5c4582624c1bfbd5725d81e622b84101d8797"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "654829fa500b94f31d798f828e69143aa6a4d978b6527ac79b0a950171f629d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "654829fa500b94f31d798f828e69143aa6a4d978b6527ac79b0a950171f629d6"
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