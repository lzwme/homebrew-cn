class Beautysh < Formula
  include Language::Python::Virtualenv

  desc "Bash beautifier"
  homepage "https:github.comlovesegfaultbeautysh"
  url "https:files.pythonhosted.orgpackages20960b7545646b036d7fa8c27fa6239ad6aeed4e83e22c1d3e408a036fb3d430beautysh-6.2.1.tar.gz"
  sha256 "423e0c87cccf2af21cae9a75e04e0a42bc6ce28469c001ee8730242e10a45acd"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "49c707e71f3f7b721c45714b1ec43ec835742d6f1e5186c49f7b6c8c0600ccc3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "49c707e71f3f7b721c45714b1ec43ec835742d6f1e5186c49f7b6c8c0600ccc3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "49c707e71f3f7b721c45714b1ec43ec835742d6f1e5186c49f7b6c8c0600ccc3"
    sha256 cellar: :any_skip_relocation, sonoma:        "2255d1071a5750e9433f548a212f6fe812a77e4193c665bb51096ef1ff1a6ea5"
    sha256 cellar: :any_skip_relocation, ventura:       "2255d1071a5750e9433f548a212f6fe812a77e4193c665bb51096ef1ff1a6ea5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "88da0dae1615bdf1277745b3364275852e2fff5eabc9c1f0af81127409e6484a"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "python@3.13"

  on_linux do
    depends_on "openssl@3"
  end

  resource "colorama" do
    url "https:files.pythonhosted.orgpackagesd8536f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "setuptools" do
    url "https:files.pythonhosted.orgpackagesc8db722a42ffdc226e950c4757b3da7b56ff5c090bb265dccd707f7b8a3c6feesetuptools-75.5.0.tar.gz"
    sha256 "5c4ccb41111392671f02bb5f8436dfc5a9a7185e80500531b133f5775c4163ef"
  end

  resource "types-colorama" do
    url "https:files.pythonhosted.orgpackages59730fb0b9fe4964b45b2a06ed41b60c352752626db46aa0fb70a49a9e283a75types-colorama-0.4.15.20240311.tar.gz"
    sha256 "a28e7f98d17d2b14fb9565d32388e419f4108f557a7d939a66319969b2b99c7a"
  end

  resource "types-setuptools" do
    url "https:files.pythonhosted.orgpackages135e3d46cd143913bd51dde973cd23b1d412de9662b08a3b8c213f26b265e6f1types-setuptools-57.4.18.tar.gz"
    sha256 "8ee03d823fe7fda0bd35faeae33d35cb5c25b497263e6a58b34c4cfd05f40bcf"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    test_file = testpath"test.sh"
    test_file.write <<~SHELL
      #!binbash
          echo "Hello, World!"
    SHELL

    system bin"beautysh", test_file

    assert_equal <<~SHELL, test_file.read
      #!binbash
      echo "Hello, World!"
    SHELL

    assert_match version.to_s, shell_output("#{bin}beautysh --version")
  end
end