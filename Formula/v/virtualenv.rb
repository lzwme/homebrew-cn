class Virtualenv < Formula
  include Language::Python::Virtualenv

  desc "Tool for creating isolated virtual python environments"
  homepage "https://virtualenv.pypa.io/"
  url "https://files.pythonhosted.org/packages/db/2e/8a70dcbe8bf15213a08f9b0325ede04faca5d362922ae0d62ef0fa4b069d/virtualenv-20.33.0.tar.gz"
  sha256 "47e0c0d2ef1801fce721708ccdf2a28b9403fa2307c3268aebd03225976f61d2"
  license "MIT"
  head "https://github.com/pypa/virtualenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b8255617a62e6d07a0cf0c80a3e0ae2a4fea702b69474edc43731954b3bc4c85"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b8255617a62e6d07a0cf0c80a3e0ae2a4fea702b69474edc43731954b3bc4c85"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b8255617a62e6d07a0cf0c80a3e0ae2a4fea702b69474edc43731954b3bc4c85"
    sha256 cellar: :any_skip_relocation, sonoma:        "84dfdd423e13c2c8930525c142c2aa9810171e69a1ab7ccc4f5dfa15b85e3b03"
    sha256 cellar: :any_skip_relocation, ventura:       "84dfdd423e13c2c8930525c142c2aa9810171e69a1ab7ccc4f5dfa15b85e3b03"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7966c0f293fce47a6e372edd76253b2e75eb8f062b1f57e0329626d468d29fe5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7966c0f293fce47a6e372edd76253b2e75eb8f062b1f57e0329626d468d29fe5"
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