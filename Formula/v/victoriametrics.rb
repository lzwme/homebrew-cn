class Victoriametrics < Formula
  desc "Cost-effective and scalable monitoring solution and time series database"
  homepage "https://victoriametrics.com/"
  url "https://ghfast.top/https://github.com/VictoriaMetrics/VictoriaMetrics/archive/refs/tags/v1.120.0.tar.gz"
  sha256 "4f62f4b6d423cfd9573aabaea5b720d8cac6b43eceee8cdfaf22f82e270a7003"
  license "Apache-2.0"

  # There are tags like `pmm-6401-v1.89.1` in the upstream repo. They don't
  # actually represent releases, despite referring to one in the tag name.
  # Make sure we only match the ones using the common format.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eb93384388c36c66c80bac5f3afcba7b6b87d971d17c8fa7c3aee177111e51d9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a54db64b4a7ec1d5f857da1a38671bec06d22f719365b6d3448cedd90f5d99ce"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "16f7bf25bb7576c0dc5813693c2bdc40a1be2467027cf0965192a0d8898ad4c5"
    sha256 cellar: :any_skip_relocation, sonoma:        "5d6260065f93b3b352ca255415d499d79e161405c0e0a0858da83c3d5e32faaf"
    sha256 cellar: :any_skip_relocation, ventura:       "c94244bd5d3816f03697b05024f650e8edd74676df33dfcb938894991415cbd6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "58ba7d4f38466971d5cc4ce777ac51de73c77572b751c0c722b1e1ccd8d59d4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9eddf5b3b2261f9be2759d85f277c258e3074896855a411963e70c1d48e5fd9f"
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