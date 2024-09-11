class Telegraf < Formula
  desc "Plugin-driven server agent for collecting & reporting metrics"
  homepage "https:www.influxdata.comtime-series-platformtelegraf"
  url "https:github.cominfluxdatatelegrafarchiverefstagsv1.32.0.tar.gz"
  sha256 "fd93a51ad0b9f050c8e0d33dcd0ba276468d8eb1f1a82c9395ae915eaa8c56c2"
  license "MIT"
  head "https:github.cominfluxdatatelegraf.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "60362124613bbadc4938b4ae9cf377dfb12b646d5ab6852f3a43b095e6c07d91"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e452a77bc9421253aa84be10efe9475ff152973693b072e6eeb9db13dd72fc30"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3664143738269b4d1ed3d58af70b08faa2cbebe8a1ddb3c0bd3844068b19042e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d40de1456e4c51f04cd8918f267ed0e53e0abe455686c0cdf1bed187cc73cbb1"
    sha256 cellar: :any_skip_relocation, sonoma:         "d942d1f587020bf8b42f9445441a1c1b605feb55bc3ce2f5ad13882b29334504"
    sha256 cellar: :any_skip_relocation, ventura:        "923c21ba02b2d7d79f0729936e2b95c37b417d084671fafccf2dcfcb3f586a1d"
    sha256 cellar: :any_skip_relocation, monterey:       "4d556d6efb4155e88f26fa969a5b8ad88015fc04b1c6254066f02336cc945b1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4ad75a8209aeeebf8075b4cd9ef051254d61104c4c8e4d2894303ea2102b46be"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.cominfluxdatatelegrafinternal.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), ".cmdtelegraf"
    (etc"telegraf.conf").write Utils.safe_popen_read(bin"telegraf", "config")
  end

  def post_install
    # Create directory for additional user configurations
    (etc"telegraf.d").mkpath
  end

  service do
    run [opt_bin"telegraf", "-config", etc"telegraf.conf", "-config-directory", etc"telegraf.d"]
    keep_alive true
    working_dir var
    log_path var"logtelegraf.log"
    error_log_path var"logtelegraf.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}telegraf --version")
    (testpath"config.toml").write shell_output("#{bin}telegraf -sample-config")
    system bin"telegraf", "-config", testpath"config.toml", "-test",
           "-input-filter", "cpu:mem"
  end
end