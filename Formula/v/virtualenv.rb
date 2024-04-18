class Virtualenv < Formula
  include Language::Python::Virtualenv

  desc "Tool for creating isolated virtual python environments"
  homepage "https:virtualenv.pypa.io"
  url "https:files.pythonhosted.orgpackages4228846fb3eb75955d191f13bca658fb0082ddcef8e2d4b6fd0c76146556f0bevirtualenv-20.25.3.tar.gz"
  sha256 "7bb554bbdfeaacc3349fa614ea5bff6ac300fc7c335e9facf3a3bcfc703f45be"
  license "MIT"
  head "https:github.compypavirtualenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "020dbf867b853838ee0c97f758ddb2d1b425da7e6e5a0297c42925f97ae9507f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "020dbf867b853838ee0c97f758ddb2d1b425da7e6e5a0297c42925f97ae9507f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "020dbf867b853838ee0c97f758ddb2d1b425da7e6e5a0297c42925f97ae9507f"
    sha256 cellar: :any_skip_relocation, sonoma:         "46b44ceec32c1c5cffc001c6e7bb60b650091e2ab5bd47198f7dec25327be22b"
    sha256 cellar: :any_skip_relocation, ventura:        "46b44ceec32c1c5cffc001c6e7bb60b650091e2ab5bd47198f7dec25327be22b"
    sha256 cellar: :any_skip_relocation, monterey:       "46b44ceec32c1c5cffc001c6e7bb60b650091e2ab5bd47198f7dec25327be22b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7baf12fa6493d9f4019ddabed18f4373550077302060bcc6c89608896a61cd33"
  end

  depends_on "python@3.12"

  resource "distlib" do
    url "https:files.pythonhosted.orgpackagesc491e2df406fb4efacdf46871c25cde65d3c6ee5e173b7e5a4547a47bae91920distlib-0.3.8.tar.gz"
    sha256 "1530ea13e350031b6312d8580ddb6b27a104275a31106523b8f123787f494f64"
  end

  resource "filelock" do
    url "https:files.pythonhosted.orgpackages38ff877f1dbe369a2b9920e2ada3c9ab81cf6fe8fa2dce45f40cad510ef2df62filelock-3.13.4.tar.gz"
    sha256 "d13f466618bfde72bd2c18255e269f72542c6e70e7bac83a0232d6b1cc5c8cf4"
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