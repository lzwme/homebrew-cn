class Victoriametrics < Formula
  desc "Cost-effective and scalable monitoring solution and time series database"
  homepage "https://victoriametrics.com/"
  url "https://ghfast.top/https://github.com/VictoriaMetrics/VictoriaMetrics/archive/refs/tags/v1.151.0.tar.gz"
  sha256 "196c757a382f473fd0c1d1388253197e79548c7f1ee656c4e2215aafd5c16080"
  license "Apache-2.0"

  # There are tags like `pmm-6401-v1.89.1` in the upstream repo. They don't
  # actually represent releases, despite referring to one in the tag name.
  # Make sure we only match the ones using the common format.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "380e5491a1653ed781a1e7000618cdcb603de6c20bc06f56e18cd2c87a80e3a3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ff0cfed0ef6b39048f1d5ca66d1894ae04f6255a6c38087175e561b5ca524b80"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "430fc33de2b8e24f87598cebecba02a64d4059aab32c5e2405051c4990d4aa9c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "f58a4d69db801c230068973d113d00a270267e31c5b70b32b62b4f625c86848a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "0a6841b92474787dc5959a374f32d15869c0cb4d285fbcee2f1c1c78b5c3d793"
    sha256 cellar: :any,                 x86_64_linux:      "d1adc572534102ce4c9858fae627720ad296cd3d6a3ad0f4fc868302a216f5ff"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X github.com/VictoriaMetrics/VictoriaMetrics/lib/buildinfo.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"victoria-metrics"), "./app/victoria-metrics"

    (etc/"victoriametrics/scrape.yml").write <<~YAML
      global:
        scrape_interval: 10s

      scrape_configs:
        - job_name: "victoriametrics"
          static_configs:
          - targets: ["127.0.0.1:8428"]
    YAML
  end

  service do
    run [
      opt_bin/"victoria-metrics",
      "-httpListenAddr=127.0.0.1:8428",
      "-promscrape.config=#{etc}/victoriametrics/scrape.yml",
      "-storageDataPath=#{var}/victoriametrics-data",
    ]
    keep_alive false
    log_path var/"log/victoria-metrics.log"
    error_log_path var/"log/victoria-metrics.err.log"
  end

  test do
    http_port = free_port

    (testpath/"scrape.yml").write <<~YAML
      global:
        scrape_interval: 10s

      scrape_configs:
        - job_name: "victoriametrics"
          static_configs:
          - targets: ["127.0.0.1:#{http_port}"]
    YAML

    pid = spawn bin/"victoria-metrics",
                "-httpListenAddr=127.0.0.1:#{http_port}",
                "-promscrape.config=#{testpath}/scrape.yml",
                "-storageDataPath=#{testpath}/victoriametrics-data"
    sleep 5
    assert_match "Single-node VictoriaMetrics", shell_output("curl -s 127.0.0.1:#{http_port}")

    assert_match version.to_s, shell_output("#{bin}/victoria-metrics --version")
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end