class Pipdeptree < Formula
  include Language::Python::Virtualenv

  desc "CLI to display dependency tree of the installed Python packages"
  homepage "https:github.comtox-devpipdeptree"
  url "https:files.pythonhosted.orgpackagesb2549c24f34c914e040f241287243a62a8cf373bfe0802dbcf7bda3a61ce06a1pipdeptree-2.21.0.tar.gz"
  sha256 "80c76708eef8263e4efc57b22151be97837aa43bfd5e81d5ec5dc7b74a04bde1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dd8891fde9852e58106e40ed2b65d0b6f3506d231a577c4d17192adb369a0b9b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "324919b35d6f5fe039e036ae5c9917cbe2388495caaaf93d0ec1ed1c4d633787"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6b1fd4a90e78caf8b905285d02322cf1eb9605fcdeeb4b0b08fad8f3f87e93f7"
    sha256 cellar: :any_skip_relocation, sonoma:         "b23f4fa6a375abcc583fd50efa47d5d46c176218a41f0b0b1d4e18842e53f4a3"
    sha256 cellar: :any_skip_relocation, ventura:        "5566db69626f3b0a46a5c830157415e541e27a7c1be884387395f4f6deb24803"
    sha256 cellar: :any_skip_relocation, monterey:       "e7d9358d1e1a5da9a393d533951dc7bfad32e9c5894765a90caad625dae39418"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a46571b2be9d6a495e0320b5f4cfbca175cdbed88fa3f6b04861a01d72e31dd4"
  end

  depends_on "python@3.12"

  resource "packaging" do
    url "https:files.pythonhosted.orgpackageseeb5b43a27ac7472e1818c4bafd44430e69605baefe1f34440593e0332ec8b4dpackaging-24.0.tar.gz"
    sha256 "eb82c5e3e56209074766e6885bb04b8c38a0c015d0a30036ebe7ece34c9989e9"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "pipdeptree==#{version}", shell_output("#{bin}pipdeptree --all")

    assert_empty shell_output("#{bin}pipdeptree --user-only").strip

    assert_equal version.to_s, shell_output("#{bin}pipdeptree --version").strip
  end
end