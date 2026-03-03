class Victoriametrics < Formula
  desc "Cost-effective and scalable monitoring solution and time series database"
  homepage "https://victoriametrics.com/"
  url "https://ghfast.top/https://github.com/VictoriaMetrics/VictoriaMetrics/archive/refs/tags/v1.137.0.tar.gz"
  sha256 "70a71f414dd83cfb97efe2ad819fc8707be4222ec8c11900d68da11de6456afc"
  license "Apache-2.0"

  # There are tags like `pmm-6401-v1.89.1` in the upstream repo. They don't
  # actually represent releases, despite referring to one in the tag name.
  # Make sure we only match the ones using the common format.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a30c010ea1330feb011770cec4ffe37b55d80ec77f28197423774d7ae49bf3cf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c51952b0dfc2c6d64df20453d3d84252947a567834138a90d72a5e67869e44e3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "28d3dd6233c0508eac79fa3c99f4ca6f53f41899095906f1d5ba8370592e2a3b"
    sha256 cellar: :any_skip_relocation, sonoma:        "5e94f7912d0fe772ef4169bd8e6ddb590fb8d8ccc5c09c2adbe45b599b5c94ba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6c781c9d2da15874cf03daa0986d9ff4ddfcdba3a62e551fb1ad184089340a96"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3beec68412f1cbb4f5fdf9b190a624bf66b9a58b8580ab1b1005af7d4fbd0fbb"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/VictoriaMetrics/VictoriaMetrics/lib/buildinfo.Version=#{version}"
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