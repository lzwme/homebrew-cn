class Victoriametrics < Formula
  desc "Cost-effective and scalable monitoring solution and time series database"
  homepage "https://victoriametrics.com/"
  url "https://ghfast.top/https://github.com/VictoriaMetrics/VictoriaMetrics/archive/refs/tags/v1.132.0.tar.gz"
  sha256 "50af0c893558b886889cf61ec1d2b8188f1cba92abe132d3fc3c84408eeab0a2"
  license "Apache-2.0"

  # There are tags like `pmm-6401-v1.89.1` in the upstream repo. They don't
  # actually represent releases, despite referring to one in the tag name.
  # Make sure we only match the ones using the common format.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3c54dab78f58fa5355aa6bb454b46600d2df71a1c91f9d9fd06d9fe7424ae087"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "10d553de0b41480ab6b76709ce63de291bc7bf06fa1fa7b7580d32157f94bd9b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a383c6ccea36063a532c3f0722defbea4970a01416f605d64c65afa21916427e"
    sha256 cellar: :any_skip_relocation, sonoma:        "bb4f76fbd0e3862e37f7cd365f0c58897560cd8414757473e13235df81ac02f3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b3a475600233561409d5d74e40e943705600a6094074552ffcb5abf02291f996"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0981cc45dd0564920f880dc3916e7d26644c98289a0e7a0906d4ffc3aafed2e4"
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