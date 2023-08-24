class Victoriametrics < Formula
  desc "Cost-effective and scalable monitoring solution and time series database"
  homepage "https://victoriametrics.com/"
  url "https://ghproxy.com/https://github.com/VictoriaMetrics/VictoriaMetrics/archive/v1.93.1.tar.gz"
  sha256 "66c12921d68de058cca2a7042b841cd57c23d014e536e610902eb36cc31ac77d"
  license "Apache-2.0"

  # There are tags like `pmm-6401-v1.89.1` in the upstream repo. They don't
  # actually represent releases, despite referring to one in the tag name.
  # Make sure we only match the ones using the common format.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "329a0f61547bb4904bdd4f81d1b4d46ac39aba77b823ef268547bacfce2b16b1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ff5c0c438cf8c91d487a17a69e51a4697c4c7f8da6c4cd04dea67975a6baad98"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3116e4d9c44f4c75b9e3299a3ae4357dc5d72afc34d3d4f26dd8dfbd802dc04c"
    sha256 cellar: :any_skip_relocation, ventura:        "cf99754a5fc68f16337dd356698ba34e530844ec4d71314fcea8d52c00f3a216"
    sha256 cellar: :any_skip_relocation, monterey:       "2b22ffcc64f0f4b8ee4dc2239a19ae1ef4163a0aa6eafeaff1552e9a2b18d162"
    sha256 cellar: :any_skip_relocation, big_sur:        "f45179b4f5386034aa75c67dd8e01533cb9726e97a51ab928256594c7303425b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c0a25f6e8cd2e2ab0051aecbfc7d1902196c4477d524fdbb8f5d0c7d78130c12"
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