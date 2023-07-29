class Victoriametrics < Formula
  desc "Cost-effective and scalable monitoring solution and time series database"
  homepage "https://victoriametrics.com/"
  url "https://ghproxy.com/https://github.com/VictoriaMetrics/VictoriaMetrics/archive/v1.92.1.tar.gz"
  sha256 "220f8723c14bbd48e374a992b15ef7542351f2918db72974f0ce8c608e16d573"
  license "Apache-2.0"

  # There are tags like `pmm-6401-v1.89.1` in the upstream repo. They don't
  # actually represent releases, despite referring to one in the tag name.
  # Make sure we only match the ones using the common format.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c0d87d81cfb730dcea7a6fd88ac22bfd1d8f056f8614bfa993427afc5e15aa0b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e1605e5b380f5b0001022d0a216a3a10846bda0fa9777eeb2152ddfd23bfca5d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f9cac239f36dfb3a5a8a593d4e912737dacb1305f0bd5ff2b01e42b278d08a43"
    sha256 cellar: :any_skip_relocation, ventura:        "68bea3d12b44c3df44504c6ac1c240e0b11551ff76d19da0a4751b556de6f2ac"
    sha256 cellar: :any_skip_relocation, monterey:       "a42a2dd5ad0ff0197f088e60502f963e6bf16fd25db94f0cc3d3b40822780f57"
    sha256 cellar: :any_skip_relocation, big_sur:        "85dc1c32371c5038f7521b5b93f738e14709d0292765b0ee7cff4a57671dbde8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "22c5c2ef7fbc670d5eb5517f9641df2dc26de7e65c7b4f8ac22c2685a82527af"
  end

  depends_on "go" => :build

  def install
    system "make", "victoria-metrics"
    bin.install "bin/victoria-metrics"

    (etc/"victoriametrics/scrape.yml").write <<~EOS
      global:
        scrape_interval: 10s

      scrape_configs:
        - job_name: "victoriametrics"
          static_configs:
          - targets: ["127.0.0.1:8428"]
    EOS
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

    (testpath/"scrape.yml").write <<~EOS
      global:
        scrape_interval: 10s

      scrape_configs:
        - job_name: "victoriametrics"
          static_configs:
          - targets: ["127.0.0.1:#{http_port}"]
    EOS

    pid = fork do
      exec bin/"victoria-metrics",
        "-httpListenAddr=127.0.0.1:#{http_port}",
        "-promscrape.config=#{testpath}/scrape.yml",
        "-storageDataPath=#{testpath}/victoriametrics-data"
    end
    sleep 3
    assert_match "Single-node VictoriaMetrics", shell_output("curl -s 127.0.0.1:#{http_port}")
  ensure
    Process.kill(9, pid)
    Process.wait(pid)
  end
end