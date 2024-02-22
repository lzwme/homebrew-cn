class Virtualenv < Formula
  include Language::Python::Virtualenv

  desc "Tool for creating isolated virtual python environments"
  homepage "https:virtualenv.pypa.io"
  url "https:files.pythonhosted.orgpackages94d7adb787076e65dc99ef057e0118e25becf80dd05233ef4c86f07aa35f6492virtualenv-20.25.0.tar.gz"
  sha256 "bf51c0d9c7dd63ea8e44086fa1e4fb1093a31e963b86959257378aef020e1f1b"
  license "MIT"
  revision 1
  head "https:github.compypavirtualenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "21e0fc767b199efeffc740e71a66e366cfab4a85d9ed923a363d89550567453a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c5e68d093dc4deea5b1df0eed3eaa1578fc08002c7e6450a5c8a3a6735850df7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "beba4e81200fb7819b6c604b9a6b1d9eb9681a2a738cdbbfa167b968c7a683f5"
    sha256 cellar: :any_skip_relocation, sonoma:         "8fb02fd0b2512955324ba5ab05c57b06c539def7d08d9b5f22f78d949d986ecf"
    sha256 cellar: :any_skip_relocation, ventura:        "75478c2ea48da3fa21d12960c7975ef83af5a12057e925f60a2a81742ce72190"
    sha256 cellar: :any_skip_relocation, monterey:       "b679cbeb524e49a471aa4af0a1caede2836e082193fcf4f82a2b177add2ef96b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "86266d2bdfad8309271b4a657e4d7abbfe2e2bfe7593f0486af673dc556c89c0"
  end

  depends_on "python@3.12"

  resource "distlib" do
    url "https:files.pythonhosted.orgpackagesc491e2df406fb4efacdf46871c25cde65d3c6ee5e173b7e5a4547a47bae91920distlib-0.3.8.tar.gz"
    sha256 "1530ea13e350031b6312d8580ddb6b27a104275a31106523b8f123787f494f64"
  end

  resource "filelock" do
    url "https:files.pythonhosted.orgpackages707041905c80dcfe71b22fb06827b8eae65781783d4a14194bce79d16a013263filelock-3.13.1.tar.gz"
    sha256 "521f5f56c50f8426f5e03ad3b281b490a87ef15bc6c526f168290f0c7148d44e"
  end

  resource "platformdirs" do
    url "https:files.pythonhosted.orgpackages96dcc1d911bf5bb0fdc58cc05010e9f3efe3b67970cef779ba7fbc3183b987a8platformdirs-4.2.0.tar.gz"
    sha256 "ef0cc731df711022c174543cb70a9b5bd22e5a9337c8624ef2c2ceb8ddad8768"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin"virtualenv", "venv_dir"
    assert_match "venv_dir", shell_output("venv_dirbinpython -c 'import sys; print(sys.prefix)'")
  end
end