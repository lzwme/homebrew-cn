class Victoriametrics < Formula
  desc "Cost-effective and scalable monitoring solution and time series database"
  homepage "https://victoriametrics.com/"
  url "https://ghfast.top/https://github.com/VictoriaMetrics/VictoriaMetrics/archive/refs/tags/v1.125.0.tar.gz"
  sha256 "85b203298a33236732baec558885ecf8a37ec1beda1e9c06eaef1d86f6878551"
  license "Apache-2.0"

  # There are tags like `pmm-6401-v1.89.1` in the upstream repo. They don't
  # actually represent releases, despite referring to one in the tag name.
  # Make sure we only match the ones using the common format.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fd68f363296cd25a234dd35ce5318f83fc9fa01b4eaf2212c37c4f17003aba80"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5cd6db16fce2f35cd115b201d2e275a606368fbbfa5919b9d9ea461972a881df"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "17bce7a7ef18d2a93c5cb63637c9472539542a194c80d8d8bcda50e0737b5925"
    sha256 cellar: :any_skip_relocation, sonoma:        "fe04e8940196ad3f1d02c2356bd1738524d8d61d5cb362cae3eaf6561b95f25e"
    sha256 cellar: :any_skip_relocation, ventura:       "2db7ec5e7d0663b433232b959d84463d432f4b0d83a34cf30a83797c4fbdc966"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "81cfbe8ad40d6bb723983af04eeb77e7ae82f6fbba73b4f7facc187353d49a35"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "005fba6b86eee0437c7902a18f9b51dcb4df216e1657cf4590939c473609ef9e"
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