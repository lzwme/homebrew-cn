class Telegraf < Formula
  desc "Plugin-driven server agent for collecting & reporting metrics"
  homepage "https://www.influxdata.com/time-series-platform/telegraf/"
  url "https://ghfast.top/https://github.com/influxdata/telegraf/archive/refs/tags/v1.35.4.tar.gz"
  sha256 "8f65d493ec0597369cea6fec8a9dfef2fc8833a44cc9291f13397481635f2a6d"
  license "MIT"
  head "https://github.com/influxdata/telegraf.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "32b76c76a211d9f82bc7173c46d3bc596b12df53346c4cbbb3faf8c0f5706433"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a40ce2bda23e47415765fa64d745fadd422bea9304c74dace38300a609a20b7c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3d8a2ef52ec35dfc9aed3c35e265160a90f2bf031e0c5bdd13c887736bb7cd74"
    sha256 cellar: :any_skip_relocation, sonoma:        "d3ce755689d77fb78b9fb1a22f9985fb0fe8feaf733551446c3a25317c9186c0"
    sha256 cellar: :any_skip_relocation, ventura:       "1c144191bc4476f02c5e70d9553a6af8895fe8250ac2497e89dc2fd71304130b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3fdd0eadd45c0b3665d84d3788b2efd14e1a0ef6aff993d2208434059af148e0"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/influxdata/telegraf/internal.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/telegraf"
    (etc/"telegraf.conf").write Utils.safe_popen_read(bin/"telegraf", "config")
  end

  def post_install
    # Create directory for additional user configurations
    (etc/"telegraf.d").mkpath
  end

  service do
    run [opt_bin/"telegraf", "-config", etc/"telegraf.conf", "-config-directory", etc/"telegraf.d"]
    keep_alive true
    working_dir var
    log_path var/"log/telegraf.log"
    error_log_path var/"log/telegraf.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/telegraf --version")
    (testpath/"config.toml").write shell_output("#{bin}/telegraf -sample-config")
    system bin/"telegraf", "-config", testpath/"config.toml", "-test",
           "-input-filter", "cpu:mem"
  end
end