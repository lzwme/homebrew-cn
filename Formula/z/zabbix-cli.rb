class ZabbixCli < Formula
  include Language::Python::Virtualenv

  desc "CLI tool for interacting with Zabbix monitoring system"
  homepage "https:github.comunioslozabbix-cli"
  url "https:github.comunioslozabbix-cliarchiverefstags2.3.2.tar.gz"
  sha256 "e56b6be1c13c42c516c8e8e6b01948fc81591eae83f8babb7bee6d2025299c26"
  license "GPL-3.0-or-later"
  revision 2
  head "https:github.comunioslozabbix-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4c8e4f88566ba9a40cfb0cd99cc5f1cd685dd9d69bb88292743b7763d5d48d5f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "449d2669fd05c6b2e6d85e16599158e1736236cde26c8547c08499b1f12acfc3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f9767693af167842797fc53388e168ceaf273c3398efc1f4750f6f98b4e8e193"
    sha256 cellar: :any_skip_relocation, sonoma:         "793913f5e3308b0c91cb1b0833e78603fcdcc3b357e9dfe93bc70c2231e2e4f4"
    sha256 cellar: :any_skip_relocation, ventura:        "0078b0fd2fa306152cc3bc16084e4ee1afdf5c5638dd90ceeecacbb78eecbdac"
    sha256 cellar: :any_skip_relocation, monterey:       "af057cb5c1956ecf483f2b704bdf030067ae86d9b576e844b8c217b4af94051f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "efdd1f9f61a969e870395346f8c580a2fbaa667d61b98f2c6bf88ab6513d08ae"
  end

  depends_on "certifi"
  depends_on "python@3.12"

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackages6309c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackages21edf86a79a07470cb07819390452f178b3bef1d375f2ec021ecfc709fc7cf07idna-3.7.tar.gz"
    sha256 "028ff3aadf0609c1fd278d8ea3089299412a7a8b9bd005dd08b9f8285bcb5cfc"
  end

  resource "packaging" do
    url "https:files.pythonhosted.orgpackageseeb5b43a27ac7472e1818c4bafd44430e69605baefe1f34440593e0332ec8b4dpackaging-24.0.tar.gz"
    sha256 "eb82c5e3e56209074766e6885bb04b8c38a0c015d0a30036ebe7ece34c9989e9"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages86ec535bf6f9bd280de6a4637526602a146a68fde757100ecf8c9333173392dbrequests-2.32.2.tar.gz"
    sha256 "dd951ff5ecf3e3b3aa26b40703ba77495dab41da839ae72ef3c8e5d8e2433289"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages7a507fd50a27caa0652cd4caf224aa87741ea41d3265ad13f010886167cfcc79urllib3-2.2.1.tar.gz"
    sha256 "d0570876c61ab9e520d776c38acbbb5b05a776d3f9ff98a5c8fd5162a444cf19"
  end

  def install
    # script tries to install config into usrlocalbin (macOS) or usrshare (Linux)
    inreplace %w[setup.py etczabbix-cli.conf zabbix_cliconfig.py], %r{(["' ])usrshare}, "\\1#{share}"
    inreplace "setup.py", "usrlocalbin", share

    virtualenv_install_with_resources
  end

  test do
    system bin"zabbix-cli-init", "-z", "https:homebrew-test.example.com"
    config = testpath".zabbix-clizabbix-cli.conf"
    assert_predicate config, :exist?
    assert_match "homebrew-test.example.com", config.read
  end
end