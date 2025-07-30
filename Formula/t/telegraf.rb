class Telegraf < Formula
  desc "Plugin-driven server agent for collecting & reporting metrics"
  homepage "https://www.influxdata.com/time-series-platform/telegraf/"
  url "https://ghfast.top/https://github.com/influxdata/telegraf/archive/refs/tags/v1.35.3.tar.gz"
  sha256 "08daec0e5682e5066fac2e2d57c6d82a32e53271600cee91746868b09ad6391a"
  license "MIT"
  head "https://github.com/influxdata/telegraf.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "564484094b25fc46313341e22341344bff1719ab1d9ef2f513c7b693a5a47180"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0f70a363bea4ee75b172e6a3b1090a84570f8f983964eb889c095e1a1de991c6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "49e925667dd5284fdeff506e5c7025f98edb09c797e7739d003d5b06924b12d7"
    sha256 cellar: :any_skip_relocation, sonoma:        "5fc03466bfaa43a2fd881f61cdc7ce954624d7bf88f68b2e5d477a7b3498f380"
    sha256 cellar: :any_skip_relocation, ventura:       "5b611233b0b632a45b7310b50151bcf7d34c133609959eda8c220b8427c22fd3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "031400c70b0ec06e9330483f89796bc19960d33c9e63b04791b6fda5730b901b"
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