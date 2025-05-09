class Victorialogs < Formula
  desc "Open source user-friendly database for logs from VictoriaMetrics"
  homepage "https:docs.victoriametrics.comvictorialogs"
  url "https:github.comVictoriaMetricsVictoriaMetricsarchiverefstagsv1.22.1-victorialogs.tar.gz"
  sha256 "f4ecd43d942490370b437d709712159a1c6f7228dcd66c143f8034f75be0a84c"
  license "Apache-2.0"

  # There are tags like `pmm-6401-v1.89.1` in the upstream repo. They don't
  # actually represent releases, despite referring to one in the tag name.
  # Make sure we only match the ones using the common format.
  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)[._-]victorialogs$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "37a3b6316830c437c18532fe1c5eb2937c66cbdfaaa8b4ffdf5bf66d153184f5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2b1f60a0877aa376b60eff933b78fc52b7d525395ac7ae897c780a3a924bb692"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "edf0ba98cf2b85440c549aeb53fcfee43cd5ff6c6c1675f441e0d5b927745c38"
    sha256 cellar: :any_skip_relocation, sonoma:        "06f069fd0a6d656caa4af4ea13d64fc4d8893192cb281b0094d3fff5c4cafa00"
    sha256 cellar: :any_skip_relocation, ventura:       "a3d775c8d1bba7fd813694c1e5cc1de59766a125b1e9b1545b54067df39b95ad"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f0349535926725c2e645446363e80be3cbb1a104a8d93ff0fd721e96ab1e7d0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a817cdb92c3e71a200cfe60fa448497bb0122fb1139d38c84d42767fa318417b"
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