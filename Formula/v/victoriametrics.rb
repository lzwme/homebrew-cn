class Victoriametrics < Formula
  desc "Cost-effective and scalable monitoring solution and time series database"
  homepage "https:victoriametrics.com"
  url "https:github.comVictoriaMetricsVictoriaMetricsarchiverefstagsv1.97.0.tar.gz"
  sha256 "99d533ca495112b8755c9f5b768ee79bc26bd729ad6e24104932736331b3178b"
  license "Apache-2.0"

  # There are tags like `pmm-6401-v1.89.1` in the upstream repo. They don't
  # actually represent releases, despite referring to one in the tag name.
  # Make sure we only match the ones using the common format.
  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d48a21d85289fb182c76f78c4299a0bf91aa69a0182e2b1e08210951571e52ab"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "798c350e968ff50a95b0ac652eb4be8535d2e999a669afe447ac47ee0f151260"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fb4dedb542084d9f52a7ea3c4775d6e8569d0d2dc4ae8e6e67d944323412162c"
    sha256 cellar: :any_skip_relocation, sonoma:         "c99028529652167f9e5753b8f0a76314ba3d0e72856044eebdab48bfb2d39a33"
    sha256 cellar: :any_skip_relocation, ventura:        "d6da56f5d3601ff313dd71a6a8ee709346472d5346d36751f7dd564d87fe43dc"
    sha256 cellar: :any_skip_relocation, monterey:       "a8b274111f247ba8de5940ed69dfafe4d92b1a0770c206a4e40972ba36a811c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5811fb84906f81d011b39a63c633e50d9fa4f69542e20caf2e21d4d07637a79c"
  end

  depends_on "go" => :build

  def install
    system "make", "victoria-metrics"
    bin.install "binvictoria-metrics"

    (etc"victoriametricsscrape.yml").write <<~EOS
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
      opt_bin"victoria-metrics",
      "-httpListenAddr=127.0.0.1:8428",
      "-promscrape.config=#{etc}victoriametricsscrape.yml",
      "-storageDataPath=#{var}victoriametrics-data",
    ]
    keep_alive false
    log_path var"logvictoria-metrics.log"
    error_log_path var"logvictoria-metrics.err.log"
  end

  test do
    http_port = free_port

    (testpath"scrape.yml").write <<~EOS
      global:
        scrape_interval: 10s

      scrape_configs:
        - job_name: "victoriametrics"
          static_configs:
          - targets: ["127.0.0.1:#{http_port}"]
    EOS

    pid = fork do
      exec bin"victoria-metrics",
        "-httpListenAddr=127.0.0.1:#{http_port}",
        "-promscrape.config=#{testpath}scrape.yml",
        "-storageDataPath=#{testpath}victoriametrics-data"
    end
    sleep 5
    assert_match "Single-node VictoriaMetrics", shell_output("curl -s 127.0.0.1:#{http_port}")
  ensure
    Process.kill(9, pid)
    Process.wait(pid)
  end
end