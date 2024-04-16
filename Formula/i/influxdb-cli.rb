class InfluxdbCli < Formula
  desc "CLI for managing resources in InfluxDB v2"
  homepage "https:influxdata.comtime-series-platforminfluxdb"
  url "https:github.cominfluxdatainflux-cli.git",
      tag:      "v2.7.4",
      revision: "ec55d42dc4214b335b05b1646293affff710cd63"
  license "MIT"
  head "https:github.cominfluxdatainflux-cli.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?((?!9\.9\.9)\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c7b202502f12061430cab1b68a0877eb8b29500758d42b94fa783347477b1777"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "65839ca1d33c62bb72d55ce088bd51d2edf1b86792e5804f99480c18abc3f82a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b1e910e4c076d8802825b849cb9b2173a37f2840914ddfd059e6b891bd24eac2"
    sha256 cellar: :any_skip_relocation, sonoma:         "db84d97b83bcb42b880f700e03e103c0795c8823571f7b64f3ab7f1c3c86899e"
    sha256 cellar: :any_skip_relocation, ventura:        "4d528c198726052c858f7000ca606119f90840244546c0b29ffa3ba7eae303fe"
    sha256 cellar: :any_skip_relocation, monterey:       "afaa17a0adc8ac5072b7ac456c3b6b1c626c312832793ca216392baa6c8bd8a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0291cafecb79ef05e371c2ab8813c10d42846422f107eed2b964237466d92fc6"
  end

  depends_on "go" => :build
  depends_on "influxdb" => :test

  def install
    ldflags = %W[
      -s
      -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_short_head(length: 10)}
      -X main.date=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(output: bin"influx", ldflags:), ".cmdinflux"

    generate_completions_from_executable(bin"influx", "completion", base_name: "influx", shells: [:bash, :zsh])
  end

  test do
    # Boot a test server.
    influxd_port = free_port
    influxd = fork do
      exec "influxd", "--bolt-path=#{testpath}influxd.bolt",
                      "--engine-path=#{testpath}engine",
                      "--http-bind-address=:#{influxd_port}",
                      "--log-level=error"
    end
    sleep 30

    # Configure the CLI for the test env.
    influx_host = "http:localhost:#{influxd_port}"
    cli_configs_path = "#{testpath}influx-configs"
    ENV["INFLUX_HOST"] = influx_host
    ENV["INFLUX_CONFIGS_PATH"] = cli_configs_path

    # Check that the CLI can connect to the server.
    assert_match "OK", shell_output("#{bin}influx ping")

    # Perform initial DB setup.
    system "#{bin}influx", "setup", "-u", "usr", "-p", "fakepassword", "-b", "bkt", "-o", "org", "-f"

    # Assert that initial resources show in CLI output.
    assert_match "usr", shell_output("#{bin}influx user list")
    assert_match "bkt", shell_output("#{bin}influx bucket list")
    assert_match "org", shell_output("#{bin}influx org list")
  ensure
    Process.kill("TERM", influxd)
    Process.wait influxd
  end
end