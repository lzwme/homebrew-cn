class Osc < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface to work with an Open Build Service"
  homepage "https://openbuildservice.org"
  url "https://ghproxy.com/https://github.com/openSUSE/osc/archive/refs/tags/1.4.3.tar.gz"
  sha256 "fda7113740893d1dcc5507c4b392073f1d8459631b52b5a793f614f820562760"
  license "GPL-2.0-or-later"
  head "https://github.com/openSUSE/osc.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d856bfaf1e27f36b3882ace466436a12d6f33d58e3b2291893e56fe9ed01bd8f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cfe852dc7ca9eeab949736db81ebc9ec539b241de012e53702b0887b7fe59057"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7ce9d69c9aaf6d9b879fc3b854631d4e78ee19386a659e0decbb8a4d8e23a263"
    sha256 cellar: :any_skip_relocation, sonoma:         "cc51d6312bd43de9ad87049cbd87106dccdd39b01f7c432741a91959c4befa01"
    sha256 cellar: :any_skip_relocation, ventura:        "f5c3f063729d2c15452d382ff0315877f8eb0b0ce0d8b2a97c277f2da799524a"
    sha256 cellar: :any_skip_relocation, monterey:       "ed83119738fa7d3767180fc84fbbc18e26b429568728098faa119a8e92df313a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "64e5f25099bbec8e6e05ac69feebf5aa37473e09925fe0e5ff94c12391f5d15e"
  end

  depends_on "cffi"
  depends_on "pycparser"
  depends_on "python-cryptography"
  depends_on "python@3.12"

  uses_from_macos "curl"

  resource "rpm" do
    url "https://files.pythonhosted.org/packages/8c/15/ef9b3d4a0b4b9afe62fd2be374003643ea03fc8026930646ad0781bb9492/rpm-0.1.0.tar.gz"
    sha256 "0e320a806fb61c3980c0cd0c5f5faec97c73c347432902ba2955a08a7b1a034f"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/af/47/b215df9f71b4fdba1025fc05a77db2ad243fa0926755a52c5e71659f4e3c/urllib3-2.0.7.tar.gz"
    sha256 "c97dfde1f7bd43a71c8d2a58e369e9b2bf692d1334ea9f9cae55add7d0dd0f84"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    test_config = testpath/"oscrc"
    ENV["OSC_CONFIG"] = test_config

    test_config.write <<~EOS
      [general]
      apiurl = https://api.opensuse.org

      [https://api.opensuse.org]
      credentials_mgr_class=osc.credentials.TransientCredentialsManager
      user=brewtest
      pass=
    EOS

    output = shell_output("#{bin}/osc status 2>&1", 1).chomp
    assert_match "Directory '.' is not a working copy", output
    assert_match "Please specify a command", shell_output("#{bin}/osc 2>&1", 2)
  end
end