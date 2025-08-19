class Victoriametrics < Formula
  desc "Cost-effective and scalable monitoring solution and time series database"
  homepage "https://victoriametrics.com/"
  url "https://ghfast.top/https://github.com/VictoriaMetrics/VictoriaMetrics/archive/refs/tags/v1.124.0.tar.gz"
  sha256 "abc832851e2e9ed2714a42c549af217669c950e088a238d665be3c8225fd6438"
  license "Apache-2.0"

  # There are tags like `pmm-6401-v1.89.1` in the upstream repo. They don't
  # actually represent releases, despite referring to one in the tag name.
  # Make sure we only match the ones using the common format.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1bdd023bc89e04ab3a75d680c17efc5478aeb83f0a81767d89b9e0f93fff1a59"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4ddeaef06fcb709caad8bc22b0a77069cf5fb24beedd5188c6db76f0d9adfe6e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "88291a266f5aeec9a39c329cd2b8458946559d3bcdcdf6675731cc7cc1489e71"
    sha256 cellar: :any_skip_relocation, sonoma:        "12921e444d7cba958e5300be12d2d3125b0b09e8079f4eae17cc13b64f9d67f1"
    sha256 cellar: :any_skip_relocation, ventura:       "52a5c3b56d22546adb3eaaf6abd8fdedfe2b50885a91560290137fe30b93eb51"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "175dc051b82262a3b7e202439f73c11377b4de3775a8ded0cb4cd0cc9ea0e462"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4d1664e1b756be428dac2d13be5de1a622e8662d202e46b64a989246383d1400"
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