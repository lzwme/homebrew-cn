class Victoriametrics < Formula
  desc "Cost-effective and scalable monitoring solution and time series database"
  homepage "https:victoriametrics.com"
  url "https:github.comVictoriaMetricsVictoriaMetricsarchiverefstagsv1.102.0.tar.gz"
  sha256 "8d683ee22c2d4d80643131a9d85d9b15559d32fbe71dd0588d02be98258f5229"
  license "Apache-2.0"

  # There are tags like `pmm-6401-v1.89.1` in the upstream repo. They don't
  # actually represent releases, despite referring to one in the tag name.
  # Make sure we only match the ones using the common format.
  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1ffa5234684ec7a5eb74ec6253552070adc6280a63a8973301a03b616394e102"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3acd0e627402317aa2af4cbc5647a6ce4aa147e7ac0892d96fb14a10eb4e8cbd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6a09aef93292b8bc286680d63b517f8f9ae94242840c5bfdce063ab2b538994e"
    sha256 cellar: :any_skip_relocation, sonoma:         "2bbaf1d9008e60f2ce969f365604c6d19a0043e58c7b057bf091324244df9e72"
    sha256 cellar: :any_skip_relocation, ventura:        "544597546ae887d2f8544215a7af2fdde8e7af19c235d0e4d3c30a66cb257bf6"
    sha256 cellar: :any_skip_relocation, monterey:       "5c307ab189ea6ad49c0d058571091a3b657d4963b1733201b96ece9823c84c02"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e0331b3007934dcb541bc4430ba90d7a00db044e2aa0adaecf72c5b2a6f34062"
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