class Victorialogs < Formula
  desc "Open source user-friendly database for logs from VictoriaMetrics"
  homepage "https:docs.victoriametrics.comvictorialogs"
  url "https:github.comVictoriaMetricsVictoriaMetricsarchiverefstagsv1.3.2-victorialogs.tar.gz"
  sha256 "efefc27abbab85dd3126201665a28fca04cf14250fb34e9a1bf93b1715382972"
  license "Apache-2.0"

  # There are tags like `pmm-6401-v1.89.1` in the upstream repo. They don't
  # actually represent releases, despite referring to one in the tag name.
  # Make sure we only match the ones using the common format.
  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)[._-]victorialogs$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a1e28feed9f7dc51c46a50c02cac743ae362c73cd26c205fc0b3658471b42f2b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "01ccd0e91b4ac50e093b0006404b81efac1e13ab832a8f3b9ce6c0f2e70707c8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "64694671962d83ab7d1f7c3968420a43d3724b07d5c188d44c75757cf7c8ebf8"
    sha256 cellar: :any_skip_relocation, sonoma:        "7ce93978693e4c5db421e504483f3f1214426444e9e8228903e9b5f94a223ee5"
    sha256 cellar: :any_skip_relocation, ventura:       "3b19dfca70e41de9a161557d3ba49cb27b8b74a8fa55ef6f2307ea4dd609206b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1ccca4900527df5a4a8d097a579ad4521473966bd952e40b7637acf19a4bb531"
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