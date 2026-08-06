class Victoriametrics < Formula
  desc "Cost-effective and scalable monitoring solution and time series database"
  homepage "https://victoriametrics.com/"
  url "https://ghfast.top/https://github.com/VictoriaMetrics/VictoriaMetrics/archive/refs/tags/v1.149.0.tar.gz"
  sha256 "468cc38046644d6725fbd148aad7eb18375ac0c543d20cae34856bb896f5bca0"
  license "Apache-2.0"

  # There are tags like `pmm-6401-v1.89.1` in the upstream repo. They don't
  # actually represent releases, despite referring to one in the tag name.
  # Make sure we only match the ones using the common format.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0c090e0c0fc7bddc4df498c041feed01975bdd032ae4a673db586dad4fa1cba9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8ee5efa9472455d5b2cbef2f2a420d8935cf4c0fd5faa27a0f885789db4b9794"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f3b4d865966dbc26b0c00fae3ef8e342cbebad6f0c75463cdccf809fddf7eb1c"
    sha256 cellar: :any_skip_relocation, sonoma:        "f7d5d10f732cc4eb4f4486872c0ea2fd11a013ffcff4f33e8206acc8b8def93c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cde21f9ece42ff2db6b49d4b7558d1f6914d09ca10629b37a8fc4703c1bea89f"
    sha256 cellar: :any,                 x86_64_linux:  "98aa371868a6c325bce8e71daf293b1508d9e2d1be4468056addecdc99a0e496"
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