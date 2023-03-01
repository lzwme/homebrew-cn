class Telegraf < Formula
  desc "Plugin-driven server agent for collecting & reporting metrics"
  homepage "https://www.influxdata.com/time-series-platform/telegraf/"
  url "https://ghproxy.com/https://github.com/influxdata/telegraf/archive/v1.25.3.tar.gz"
  sha256 "b2b0ec6c1f698a8f5f8af75cf932a14e53b2eff57f959c4bae8d6c71dc363773"
  license "MIT"
  head "https://github.com/influxdata/telegraf.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "465c1082e8e571e0dacb7aae7e9e1eca807f70d86488e02aab70fa04012a1fa9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a4d1ff3b19ed7cac33251aff2bd7176e6316f2786ca1ace5abde0592b7622e2e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4bbda4c9c2823121d218cc64a73cf505b7024dd253624faae9c0ac17ebfe8e51"
    sha256 cellar: :any_skip_relocation, ventura:        "73234ba44705ee005abf7ddb9194bb956a9ba3f655e27f4b236ef2a9745b38f5"
    sha256 cellar: :any_skip_relocation, monterey:       "c5c5b493d55a409fa0c728446455ceb9ba693eb205bc1877669561d62c08d137"
    sha256 cellar: :any_skip_relocation, big_sur:        "d4e3b26f4ff15bf90258dcd68aaabf5fb1aaaa9d92a3116e51b2f03d74a25f62"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dbb61b15aaaf8d5344552c984d2f9d541c0dd775b971650fd48e11f88e21e1d8"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/influxdata/telegraf/internal.Version=#{version}"), "./cmd/telegraf"
    etc.install "etc/telegraf.conf" => "telegraf.conf"
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