class Virtualenv < Formula
  include Language::Python::Virtualenv

  desc "Tool for creating isolated virtual python environments"
  homepage "https:virtualenv.pypa.io"
  url "https:files.pythonhosted.orgpackages3f40abc5a766da6b0b2457f819feab8e9203cbeae29327bd241359f866a3da9dvirtualenv-20.26.6.tar.gz"
  sha256 "280aede09a2a5c317e409a00102e7077c6432c5a38f0ef938e643805a7ad2c48"
  license "MIT"
  head "https:github.compypavirtualenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4f2b20dbdec6d5561d0c126c4ec8bc627e9a6e846c0182abbbee382beca9abf0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4f2b20dbdec6d5561d0c126c4ec8bc627e9a6e846c0182abbbee382beca9abf0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4f2b20dbdec6d5561d0c126c4ec8bc627e9a6e846c0182abbbee382beca9abf0"
    sha256 cellar: :any_skip_relocation, sonoma:        "fdc37ba06e5d9e41781d0c2523e9d71f2ad43d3b328eaa8397245592b1db20c8"
    sha256 cellar: :any_skip_relocation, ventura:       "fdc37ba06e5d9e41781d0c2523e9d71f2ad43d3b328eaa8397245592b1db20c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3aa0ae038e837ac7726ce3c9dcc0ad399567cc4490c84e9f848d2a500721e915"
  end

  depends_on "python@3.12"

  resource "distlib" do
    url "https:files.pythonhosted.orgpackagesc491e2df406fb4efacdf46871c25cde65d3c6ee5e173b7e5a4547a47bae91920distlib-0.3.8.tar.gz"
    sha256 "1530ea13e350031b6312d8580ddb6b27a104275a31106523b8f123787f494f64"
  end

  resource "filelock" do
    url "https:files.pythonhosted.orgpackages9ddb3ef5bb276dae18d6ec2124224403d1d67bccdbefc17af4cc8f553e341ab1filelock-3.16.1.tar.gz"
    sha256 "c249fbfcd5db47e5e2d6d62198e565475ee65e4831e2561c8e313fa7eb961435"
  end

  resource "platformdirs" do
    url "https:files.pythonhosted.orgpackages13fc128cc9cb8f03208bdbf93d3aa862e16d376844a14f9a0ce5cf4507372de4platformdirs-4.3.6.tar.gz"
    sha256 "357fb2acbc885b0419afd3ce3ed34564c13c9b95c89360cd9563f73aa5e2b907"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin"virtualenv", "venv_dir"
    assert_match "venv_dir", shell_output("venv_dirbinpython -c 'import sys; print(sys.prefix)'")
  end
end