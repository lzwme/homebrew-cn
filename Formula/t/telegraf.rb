class Telegraf < Formula
  desc "Plugin-driven server agent for collecting & reporting metrics"
  homepage "https:www.influxdata.comtime-series-platformtelegraf"
  url "https:github.cominfluxdatatelegrafarchiverefstagsv1.35.0.tar.gz"
  sha256 "990ad5eba041aa5bf91f5ca107b86d19cbbe14eddb1e822950c2a30356a78a80"
  license "MIT"
  head "https:github.cominfluxdatatelegraf.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f44c24aac697b39566d2303ae37cf8588b95692f9c2467835c1678cb0d1503a4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9265b9600b216a3876c26c9da23cc626b59cffe6c7ff7b2cdf5c70096b4f2ac3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "30cc1c227cc94398051cc0c639a70c58b9555c4da90fd5af368e9a1c74d5cc74"
    sha256 cellar: :any_skip_relocation, sonoma:        "cacc1c62709517ca2483f479dbbf38419bf8d45dca35ef4cdc09da2a08d60f6e"
    sha256 cellar: :any_skip_relocation, ventura:       "9930cc62bbecdaaedf2cd9146844ba5f975eaf9c68eb9f5f29ed0ee3fbcf9ae7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0ff6d06dd1461d61d64d9a8aba32e39bcedc32c5b4d050dc69782b1833d17dd8"
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