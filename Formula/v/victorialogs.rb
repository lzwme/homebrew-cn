class Victorialogs < Formula
  desc "Open source user-friendly database for logs from VictoriaMetrics"
  homepage "https:docs.victoriametrics.comvictorialogs"
  url "https:github.comVictoriaMetricsVictoriaMetricsarchiverefstagsv1.10.0-victorialogs.tar.gz"
  sha256 "f9ca082f675ceabf531b32583f75274cfe455a39f67e9c0b765d4743377a9f17"
  license "Apache-2.0"

  # There are tags like `pmm-6401-v1.89.1` in the upstream repo. They don't
  # actually represent releases, despite referring to one in the tag name.
  # Make sure we only match the ones using the common format.
  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)[._-]victorialogs$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cc64b472463e0e9503ae6b46ff34f35bc1fe79f6bb1aac823137280b6c6d33ff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1dfa160cb95458a36f11f627f1c4cc251f120691a3ae5b148c1d5c688ccc72af"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "edaf8c104df66339255bad07e7779ae2cd8e45acb60fa02040adacebdd83d969"
    sha256 cellar: :any_skip_relocation, sonoma:        "35a4459fd2b3384f80293f9f2dcfde25e55a78effb612200d0e62d2bc8cdc99f"
    sha256 cellar: :any_skip_relocation, ventura:       "18b288a5ef7e09f0005266fc80e269b79bd1cb03133de541909bb2b23e2b2bea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c048a916ec5cccd5858f0998c0ad61f878cf1ef751378a0ac4330d74e85e6c13"
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