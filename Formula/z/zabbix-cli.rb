class ZabbixCli < Formula
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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "14d3bc46edbe683f3bbf1b0242fb6bd71626f7cc5d00223111d8a1ae32acdd51"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8dfb1bb13c3ca82e02349f7b3a9424752caee80523241d8b6d0892b0ac6472fd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b411fbb46fea9923c277aa57bd0a7f4b40f9ea32c058e2c91080f39a4765365e"
    sha256 cellar: :any_skip_relocation, sonoma:         "c4946145ce6eea493bf84289e95d1b95aef981c09892752ff7ca3271677e0c3f"
    sha256 cellar: :any_skip_relocation, ventura:        "2aa50f2136732eb62371b47a58a1eb8ac9bf28e78396fbc863925e7fe473dd6d"
    sha256 cellar: :any_skip_relocation, monterey:       "11f5089c40ecea4ec35bb120932a32c86132be9c006559824395bf33c35796e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "332ce3671efa9cbaf4fc2e49198adf35423ef476f1fddcc144e30ec1017e3b51"
  end

  depends_on "python-setuptools" => :build
  depends_on "python-requests"
  depends_on "python@3.12"

  def python3
    "python3.12"
  end

  def install
    # script tries to install config into /usr/local/bin (macOS) or /usr/share (Linux)
    inreplace %w[setup.py etc/zabbix-cli.conf zabbix_cli/config.py], %r{(["' ])/usr/share/}, "\\1#{share}/"
    inreplace "setup.py", "/usr/local/bin", share

    system python3, "-m", "pip", "install", *std_pip_args, "."
  end

  test do
    system bin/"zabbix-cli-init", "-z", "https://homebrew-test.example.com/"
    config = testpath/".zabbix-cli/zabbix-cli.conf"
    assert_predicate config, :exist?
    assert_match "homebrew-test.example.com", config.read
  end
end