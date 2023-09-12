class Telegraf < Formula
  desc "Plugin-driven server agent for collecting & reporting metrics"
  homepage "https://www.influxdata.com/time-series-platform/telegraf/"
  url "https://ghproxy.com/https://github.com/influxdata/telegraf/archive/refs/tags/v1.28.0.tar.gz"
  sha256 "739a2bb123c7a8b00cca4f4f6130f0f675bb52aa911eb0e23594dfa9e0103cc3"
  license "MIT"
  head "https://github.com/influxdata/telegraf.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "16a077aa3c91c4bb9a7d8639a4a7afe447cffc43c734f1226f7e80c68178e4af"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "56d9223b29bc114bbe6fc836532d3ca0943a45482baf1bb26f5e5ae900cdca17"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d34e1a38e61a0e56b7abdcfe2e7d921cc13e79868f2aa81dee7c9ee547cf96ea"
    sha256 cellar: :any_skip_relocation, ventura:        "06b7ec5b2492705e302198c16a1b65684a50b3fff365fbe5ed603b5d08337e28"
    sha256 cellar: :any_skip_relocation, monterey:       "cbd3b7eb7f0b99736fa98d684f35b0ae35c940727c930359b1910fc3c98703a8"
    sha256 cellar: :any_skip_relocation, big_sur:        "e86c95e5be74bfddc8e62e141b3d1b1fe441672ad5e678c185b5b68b3490888d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c376009c0827873cdfd9414dffb61334cce86c5ee3b8631a994b576b8c6277d3"
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