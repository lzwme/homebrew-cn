class Telegraf < Formula
  desc "Plugin-driven server agent for collecting & reporting metrics"
  homepage "https://www.influxdata.com/time-series-platform/telegraf/"
  url "https://ghfast.top/https://github.com/influxdata/telegraf/archive/refs/tags/v1.36.0.tar.gz"
  sha256 "8752209f0539c2c73f2ce69c22a05ab62bf50fe0b3e63db0eb6fd8f3d91ce646"
  license "MIT"
  head "https://github.com/influxdata/telegraf.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b848c63a2fe5f716272bc845230f206a7bbbb3e1052f095533b84534a4344ac7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "20d514ebd19b88d77bdd8846d28b7c5a08831958e568e37537598ccc82d36716"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a6cd946d434658d6f9aa2cdd57561289cbbe559872e181a540cf6dfa3b18c9b7"
    sha256 cellar: :any_skip_relocation, sonoma:        "fc4135d547357153b39726042b9ae63c11d0a35eb0ac336a56f93d946ff3b784"
    sha256 cellar: :any_skip_relocation, ventura:       "ae7fb2929154f6aec3eb2d55290cafcf6e63e2506cb0878eadba92c66691c7de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8e3b503706d3091917ec081869fbfb474debd6ef38fd9d966067b7e18d44e8d3"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/influxdata/telegraf/internal.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/telegraf"

    (buildpath/"telegraf.conf").write Utils.safe_popen_read(bin/"telegraf", "config")
    etc.install "telegraf.conf"
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
    system bin/"telegraf", "-config", testpath/"config.toml", "-test", "-input-filter", "cpu:mem"
  end
end