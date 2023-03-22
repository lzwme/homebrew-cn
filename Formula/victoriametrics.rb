class Victoriametrics < Formula
  desc "Cost-effective and scalable monitoring solution and time series database"
  homepage "https://victoriametrics.com/"
  url "https://ghproxy.com/https://github.com/VictoriaMetrics/VictoriaMetrics/archive/v1.88.1.tar.gz"
  sha256 "92803ae61f927b7173e25d4537c429bf3054edfa2f719bafc8fb9fcd411cab87"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "951ac70f146c347722a110385c3d07fefda570a5312b939ae40d7faa207c3a50"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "80d0aec2b6a5e077dc2d10abab4784e8b38d121a53873464f311eec6b419d813"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "62a460227ed8fa518d3832a3c168e191fdccc0f26f412495a6ce21cd590c9956"
    sha256 cellar: :any_skip_relocation, ventura:        "bab9784abc9c7f58e2786963b11d9d3532dda32137bba1a9121bacbdbf6a135f"
    sha256 cellar: :any_skip_relocation, monterey:       "a71069a82c7cc3a2b602b7193e1ad852bd57d571869d7a0898f77e8b035beaf8"
    sha256 cellar: :any_skip_relocation, big_sur:        "99cc79e729621b490bfcbea5109b51273aee215774d73f9275e7ddbf718fd186"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c00af9f98e4467f86e10dd40cfafc2738d0d06987c612a66107f62be59d633d5"
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