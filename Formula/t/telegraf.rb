class Telegraf < Formula
  desc "Plugin-driven server agent for collecting & reporting metrics"
  homepage "https://www.influxdata.com/time-series-platform/telegraf/"
  url "https://ghproxy.com/https://github.com/influxdata/telegraf/archive/refs/tags/v1.28.3.tar.gz"
  sha256 "0c65649c4b761b2a1403237ec48fa0c27b4c91320f3f5e178692bfa7ca1769f6"
  license "MIT"
  head "https://github.com/influxdata/telegraf.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c0f36382abba0baba096a2029c26ba2b8f4feb0871d400e9c4835f66a7d60bbd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "335958f6516778dbdf4c9f912e36870878878d9b74ce3c81d471c39b90944926"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "05328856aac05e5b1f2b27a22e6a462197efe34a03d5a8fa45a7a6bb1b9a41ab"
    sha256 cellar: :any_skip_relocation, sonoma:         "01e976c6a7201b7df2e5b7c0b58de2ebe7a1122ff8e4c1f9143fdcc044de557e"
    sha256 cellar: :any_skip_relocation, ventura:        "14b52877f0df81350eaa2f58a78bb66a8fd7481c288da63b3312c484f24ed49f"
    sha256 cellar: :any_skip_relocation, monterey:       "14d479a974dd684d6d3e508c928f1e07ff0c478c08725f760bd6b889fcfd772e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b8dd1a83f150fbc0cf27a93cd728e9c49423f8f283e4e265e684e4c6597171eb"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/influxdata/telegraf/internal.Version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/telegraf"
    (etc/"telegraf.conf").write Utils.safe_popen_read("#{bin}/telegraf", "config")
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
    system "#{bin}/telegraf", "-config", testpath/"config.toml", "-test",
           "-input-filter", "cpu:mem"
  end
end