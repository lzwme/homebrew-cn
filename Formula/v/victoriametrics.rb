class Victoriametrics < Formula
  desc "Cost-effective and scalable monitoring solution and time series database"
  homepage "https://victoriametrics.com/"
  url "https://ghfast.top/https://github.com/VictoriaMetrics/VictoriaMetrics/archive/refs/tags/v1.135.0.tar.gz"
  sha256 "bf7d192374d68db3fb5f4fc0038bfc783a8ec8c713605b24d4b0bde65d81a9e9"
  license "Apache-2.0"

  # There are tags like `pmm-6401-v1.89.1` in the upstream repo. They don't
  # actually represent releases, despite referring to one in the tag name.
  # Make sure we only match the ones using the common format.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c71f78a558576bfaad2c94f8e9222d43fd471efd0671461dee9901220f20a47e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "71de3c15b6f26deb496a227c249707ef04cfd0b965ccc3f6377307dab54f3490"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4f4b386220269432eaf0b30dd8f71ecbb574be61945a8a868bf2dd51cc377384"
    sha256 cellar: :any_skip_relocation, sonoma:        "25a25271d4220d336c32326e2039e712dc59c6bae5d55c38217105eca52194c4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "20f1ff91a5816afdd66dac276aae54d45a94c47a27caf0baa98b3ea5e7c887ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "40e5efa6e864ec9f39e5c4d7cefe1765b879c92e588a77944f363bdddbc7aa4c"
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