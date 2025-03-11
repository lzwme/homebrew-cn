class Telegraf < Formula
  desc "Plugin-driven server agent for collecting & reporting metrics"
  homepage "https:www.influxdata.comtime-series-platformtelegraf"
  url "https:github.cominfluxdatatelegrafarchiverefstagsv1.34.0.tar.gz"
  sha256 "0bdaf8c8e306bbf514418c7de1da00d5d1ba14617ba69eacdd13f6796e4ff4ea"
  license "MIT"
  head "https:github.cominfluxdatatelegraf.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8f345c063c5e9cd332544cce65abbe78c783becc488495aa1821495ea8c5cf1b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "02590e5468dece11e031772c512e2b4e312fc39a5c981113d77d7160fc5e4449"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "85070e23cdc2f3a4a7a14d06e36902a38705d403f313c0c9845c1685929d4689"
    sha256 cellar: :any_skip_relocation, sonoma:        "dbc9c5f29a07c17eb0d0298f97f29dab296458aa074ad125deea7adaef8bd5c2"
    sha256 cellar: :any_skip_relocation, ventura:       "40470ad2e2fa2dd6ab272ea6921aa46606949338fa6cbc63a54867c30a7bbcb5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9b02f64ddf6794fae8efb96d95f3d3dcfe0643086693247c98478545a711db57"
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