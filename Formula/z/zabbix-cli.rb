class ZabbixCli < Formula
  include Language::Python::Virtualenv

  desc "CLI tool for interacting with Zabbix monitoring system"
  homepage "https://github.com/unioslo/zabbix-cli/"
  url "https://ghproxy.com/https://github.com/unioslo/zabbix-cli/archive/refs/tags/2.3.1.tar.gz"
  sha256 "1d6de0486a5cd6b4fdd53c35810bd14e423ed039ed7ad0865ea08f6082309564"
  license "GPL-3.0-or-later"
  revision 4
  head "https://github.com/unioslo/zabbix-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "642ffe700f81b54022cd4498af1dc1e5d82f8ee7c408b633c438ac1ca3b818dc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "703124d0588e3ce655d2a3519a556c39547e8fb72751c6bca9ecb40d71e56cbe"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "139cba1805f28b7d8667fc78aa5a2647b6cb6b66bfc8c593a21f8bbf55993d4c"
    sha256 cellar: :any_skip_relocation, sonoma:         "14509f5004c729fe5a9e68a683c2cab5172b6f50424dca819e6943dff9f2fbd8"
    sha256 cellar: :any_skip_relocation, ventura:        "c7e1101ab39e7bb2a466aa21fdff21dacaf81a2ed6353dee127d64d5a5ecb6d9"
    sha256 cellar: :any_skip_relocation, monterey:       "34d01b3935aeba3bcd27d3754b1f848bfef4dfc920e083b090aa079094fc757d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4e755c98bf015c689e0b3b2b88e077cd37cf225d6c91f89b9fafd0782e950100"
  end

  depends_on "python-certifi"
  depends_on "python@3.12"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/cf/ac/e89b2f2f75f51e9859979b56d2ec162f7f893221975d244d8d5277aa9489/charset-normalizer-3.3.0.tar.gz"
    sha256 "63563193aec44bce707e0c5ca64ff69fa72ed7cf34ce6e11d5127555756fd2f6"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/af/47/b215df9f71b4fdba1025fc05a77db2ad243fa0926755a52c5e71659f4e3c/urllib3-2.0.7.tar.gz"
    sha256 "c97dfde1f7bd43a71c8d2a58e369e9b2bf692d1334ea9f9cae55add7d0dd0f84"
  end

  def install
    # script tries to install config into /usr/local/bin (macOS) or /usr/share (Linux)
    inreplace %w[setup.py etc/zabbix-cli.conf zabbix_cli/config.py], %r{(["' ])/usr/share/}, "\\1#{share}/"
    inreplace "setup.py", "/usr/local/bin", share

    virtualenv_install_with_resources
  end

  test do
    system bin/"zabbix-cli-init", "-z", "https://homebrew-test.example.com/"
    config = testpath/".zabbix-cli/zabbix-cli.conf"
    assert_predicate config, :exist?
    assert_match "homebrew-test.example.com", config.read
  end
end