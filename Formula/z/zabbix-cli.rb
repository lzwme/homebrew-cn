class ZabbixCli < Formula
  desc "CLI tool for interacting with Zabbix monitoring system"
  homepage "https:github.comunioslozabbix-cli"
  url "https:github.comunioslozabbix-cliarchiverefstags2.3.2.tar.gz"
  sha256 "e56b6be1c13c42c516c8e8e6b01948fc81591eae83f8babb7bee6d2025299c26"
  license "GPL-3.0-or-later"
  head "https:github.comunioslozabbix-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6045d4260ee1e3eb050119e8e80f0b1daaf78551e73b9cbdc4f95310f15ca97d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8f3fffae3994bfd7553bc828f97a42fc183313429c0c283796605b5d0f18bff1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5f5bc8108f0c921e6dc2045bfe508e781a5b1aea230151176c1ef5db821c420c"
    sha256 cellar: :any_skip_relocation, sonoma:         "7c95788d0967958bde73a30a203cf13a42182aeefe56f63d2c09fed0523135f1"
    sha256 cellar: :any_skip_relocation, ventura:        "fe978e32953f9a0f3e79638f0ad27a5ee51713059d7fad86bcfe789316a21525"
    sha256 cellar: :any_skip_relocation, monterey:       "72da57d05cf66f8f06cbe00ec3e7a501418447030be66a9504f7b370ffd79cc4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "58ab30317704c5affc8a4dd85d1b4a74e4b9e7557284cd6c02c10b474edfc6dc"
  end

  depends_on "python-setuptools" => :build
  depends_on "python-requests"
  depends_on "python@3.12"

  def python3
    "python3.12"
  end

  def install
    # script tries to install config into usrlocalbin (macOS) or usrshare (Linux)
    inreplace %w[setup.py etczabbix-cli.conf zabbix_cliconfig.py], %r{(["' ])usrshare}, "\\1#{share}"
    inreplace "setup.py", "usrlocalbin", share

    system python3, "-m", "pip", "install", *std_pip_args, "."
  end

  test do
    system bin"zabbix-cli-init", "-z", "https:homebrew-test.example.com"
    config = testpath".zabbix-clizabbix-cli.conf"
    assert_predicate config, :exist?
    assert_match "homebrew-test.example.com", config.read
  end
end