class Virtualenv < Formula
  include Language::Python::Virtualenv

  desc "Tool for creating isolated virtual python environments"
  homepage "https:virtualenv.pypa.io"
  url "https:files.pythonhosted.orgpackages848a134f65c3d6066153b84fc176c58877acd8165ed0b79a149ff50502597284virtualenv-20.26.4.tar.gz"
  sha256 "c17f4e0f3e6036e9f26700446f85c76ab11df65ff6d8a9cbfad9f71aabfcf23c"
  license "MIT"
  head "https:github.compypavirtualenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "2910ef9ae5feb293c08513b16a4f1cde6b29276d36475a0a1808567c0422c62c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d292e29a19ec140d18697ffeafb60cb0b802133889a7532ca41b865178c32562"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d292e29a19ec140d18697ffeafb60cb0b802133889a7532ca41b865178c32562"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d292e29a19ec140d18697ffeafb60cb0b802133889a7532ca41b865178c32562"
    sha256 cellar: :any_skip_relocation, sonoma:         "bd27a2e6b03745a7d0f7f9618da031ad1d6f32676e1c42d174542c95124b2999"
    sha256 cellar: :any_skip_relocation, ventura:        "bd27a2e6b03745a7d0f7f9618da031ad1d6f32676e1c42d174542c95124b2999"
    sha256 cellar: :any_skip_relocation, monterey:       "bd27a2e6b03745a7d0f7f9618da031ad1d6f32676e1c42d174542c95124b2999"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0a9349c500227d72dae359703f1681d812fc5865a959e01a6cf5cb82dee6203d"
  end

  depends_on "python@3.12"

  resource "distlib" do
    url "https:files.pythonhosted.orgpackagesc491e2df406fb4efacdf46871c25cde65d3c6ee5e173b7e5a4547a47bae91920distlib-0.3.8.tar.gz"
    sha256 "1530ea13e350031b6312d8580ddb6b27a104275a31106523b8f123787f494f64"
  end

  resource "filelock" do
    url "https:files.pythonhosted.orgpackagese6763981447fd369539aba35797db99a8e2ff7ed01d9aa63e9344a31658b8d81filelock-3.16.0.tar.gz"
    sha256 "81de9eb8453c769b63369f87f11131a7ab04e367f8d97ad39dc230daa07e3bec"
  end

  resource "platformdirs" do
    url "https:files.pythonhosted.orgpackageseab10d84052c168ca3a712ca01be2b8f55af8a3d5b644e02276e02c3a0ac2b90platformdirs-4.3.1.tar.gz"
    sha256 "63b79589009fa8159973601dd4563143396b35c5f93a58b36f9049ff046949b1"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin"virtualenv", "venv_dir"
    assert_match "venv_dir", shell_output("venv_dirbinpython -c 'import sys; print(sys.prefix)'")
  end
end