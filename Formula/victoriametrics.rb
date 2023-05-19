class Victoriametrics < Formula
  desc "Cost-effective and scalable monitoring solution and time series database"
  homepage "https://victoriametrics.com/"
  url "https://ghproxy.com/https://github.com/VictoriaMetrics/VictoriaMetrics/archive/v1.91.0.tar.gz"
  sha256 "2cba14d7daebee621b1d9893e4f7d1c85935584bf64d9e26204666580b392baf"
  license "Apache-2.0"

  # There are tags like `pmm-6401-v1.89.1` in the upstream repo. They don't
  # actually represent releases, despite referring to one in the tag name.
  # Make sure we only match the ones using the common format.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7f391fd1005164ccd8fb273c2f9f577873be02293406f97b2df893dd50eaab62"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1af14106acdffb17181099a421acfd89a2a30680c877d3580fb38ce077ef4d49"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7f810f8c98defd17ec30875ed7a0182f26787dc0abc62ff030265ebfd42c57e2"
    sha256 cellar: :any_skip_relocation, ventura:        "63a769f7c25b9afa076d98de63de88ab80767506cb0c26cad1f209e97e792725"
    sha256 cellar: :any_skip_relocation, monterey:       "2be1c8a333d47804962b2ed7a5e6daf4d9ead97427d49237ec4734603508822b"
    sha256 cellar: :any_skip_relocation, big_sur:        "876a082c06ed4701076ac820143620eb7a12c8248ec854b54be14ab89af2ba1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9fbad949527a49e23f46c3f0f878a4b31b9f9967b323537746166f51a828c827"
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