class Victoriametrics < Formula
  desc "Cost-effective and scalable monitoring solution and time series database"
  homepage "https://victoriametrics.com/"
  url "https://ghfast.top/https://github.com/VictoriaMetrics/VictoriaMetrics/archive/refs/tags/v1.128.0.tar.gz"
  sha256 "996784c0ca9fba285a1ae30613bd2a930e9df05b0bb80ca46b949fb180a0fae0"
  license "Apache-2.0"

  # There are tags like `pmm-6401-v1.89.1` in the upstream repo. They don't
  # actually represent releases, despite referring to one in the tag name.
  # Make sure we only match the ones using the common format.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a82e9b973924e60e395ca85ef3b3becbbf5a8dcce887c47ab06fd1d62bbbabe1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ee1d7cee9d78b26c04cc373322f1f3cb901cba379ce0dfe013fe16738744f4b5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "62c2a83017c3b6754f00932bfc88de1342d656bf947abccaa6644ec685d7b066"
    sha256 cellar: :any_skip_relocation, sonoma:        "38f80ad2f80cf332131e6f8bee0d83190f81024192a0ed407b82c0dfe28115ce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f06930febd32fd2691e2c75fce448afb45a15a1f83c3449f895ce02ae0d9bf16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "942827436d3e92c3efae7b486378117af3ee3d1308f29f20c345398d5f9ea52d"
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

    pid = fork do
      exec bin/"victoria-metrics",
        "-httpListenAddr=127.0.0.1:#{http_port}",
        "-promscrape.config=#{testpath}/scrape.yml",
        "-storageDataPath=#{testpath}/victoriametrics-data"
    end
    sleep 5
    assert_match "Single-node VictoriaMetrics", shell_output("curl -s 127.0.0.1:#{http_port}")

    assert_match version.to_s, shell_output("#{bin}/victoria-metrics --version")
  ensure
    Process.kill(9, pid)
    Process.wait(pid)
  end
end