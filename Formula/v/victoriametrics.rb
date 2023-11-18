class Victoriametrics < Formula
  desc "Cost-effective and scalable monitoring solution and time series database"
  homepage "https://victoriametrics.com/"
  url "https://ghproxy.com/https://github.com/VictoriaMetrics/VictoriaMetrics/archive/refs/tags/v1.95.1.tar.gz"
  sha256 "23947cda1a68d03ec1ec0814b565a9872df98512ccdf918d32cc5aa5679f97ef"
  license "Apache-2.0"

  # There are tags like `pmm-6401-v1.89.1` in the upstream repo. They don't
  # actually represent releases, despite referring to one in the tag name.
  # Make sure we only match the ones using the common format.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "deda6034dc063925060586ac918e38c1b8bd482cfcb8fe0491c61bff2b80cae3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5348f2d4f1eb65f09bd0fc87eb61187cda21ee6387e00c596ec4b7b7b80e9751"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "53d62ab7b90306761af32c582988d491e04ab0e312de0d44cc10ef3a7bc6f873"
    sha256 cellar: :any_skip_relocation, sonoma:         "66c0da7061a32ed45e431242d1f5c09a0e74a5bdeac72c95b97725782ac44bcb"
    sha256 cellar: :any_skip_relocation, ventura:        "00eb4010b7b1b9efcffc5639c0948e4294f6b69b0deb8b72e7c8c8ea8f5aa41f"
    sha256 cellar: :any_skip_relocation, monterey:       "ad7d22f792a7551a1d2206f8f9ed0d32031bdd71efcda79c9fe806fccd8d3ec8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f2f0c00ae85edab1244f9c34f850aa18b11a75b3534888195721a8206cd288e4"
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
    sleep 5
    assert_match "Single-node VictoriaMetrics", shell_output("curl -s 127.0.0.1:#{http_port}")
  ensure
    Process.kill(9, pid)
    Process.wait(pid)
  end
end