class Victorialogs < Formula
  desc "Open source user-friendly database for logs from VictoriaMetrics"
  homepage "https:docs.victoriametrics.comvictorialogs"
  url "https:github.comVictoriaMetricsVictoriaMetricsarchiverefstagsv1.11.0-victorialogs.tar.gz"
  sha256 "7a61d0d415d8a31d531521139ebfce26b3c873d01124ae52374399ef93fdc51e"
  license "Apache-2.0"

  # There are tags like `pmm-6401-v1.89.1` in the upstream repo. They don't
  # actually represent releases, despite referring to one in the tag name.
  # Make sure we only match the ones using the common format.
  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)[._-]victorialogs$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eacbef7dc4875f56964909ee1eae4f3070b09936e18e1e921e301ca60279f6bb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c21282130d15b36b3622465ef4bbc8dfec5e181ee0bc47128931421893ab9201"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6b281a18e77d4904b3359d3908eb8ddd3690db8af1d575b42c76e9f149b49e4c"
    sha256 cellar: :any_skip_relocation, sonoma:        "990a2815001ac8454702c2c0efbed6853315a33c110558f72992bf077fce1b01"
    sha256 cellar: :any_skip_relocation, ventura:       "e4d31bc0478c774516f066279e9f765c41028d73c98013c2fb4cda44d507893f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fc3d40f0a65b395765779d52003b56e780bae37a8b223dcc8f631e811d8d81a3"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.comVictoriaMetricsVictoriaMetricslibbuildinfo.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin"victoria-logs"), ".appvictoria-logs"
  end

  service do
    run [
      opt_bin"victoria-logs",
      "-httpListenAddr=127.0.0.1:9428",
      "-storageDataPath=#{var}victorialogs-data",
    ]
    keep_alive false
    log_path var"logvictoria-logs.log"
    error_log_path var"logvictoria-logs.err.log"
  end

  test do
    http_port = free_port

    pid = fork do
      exec bin"victoria-logs",
        "-httpListenAddr=127.0.0.1:#{http_port}",
        "-storageDataPath=#{testpath}victorialogs-data"
    end
    sleep 5
    assert_match "Single-node VictoriaLogs", shell_output("curl -s 127.0.0.1:#{http_port}")

    assert_match version.to_s, shell_output("#{bin}victoria-logs --version")
  ensure
    Process.kill(9, pid)
    Process.wait(pid)
  end
end