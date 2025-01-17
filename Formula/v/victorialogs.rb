class Victorialogs < Formula
  desc "Open source user-friendly database for logs from VictoriaMetrics"
  homepage "https:docs.victoriametrics.comvictorialogs"
  url "https:github.comVictoriaMetricsVictoriaMetricsarchiverefstagsv1.6.1-victorialogs.tar.gz"
  sha256 "aab821b74a4e8ba1a5730bf84b5a5a16de8c4de2893095400b027d38720e0eb6"
  license "Apache-2.0"

  # There are tags like `pmm-6401-v1.89.1` in the upstream repo. They don't
  # actually represent releases, despite referring to one in the tag name.
  # Make sure we only match the ones using the common format.
  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)[._-]victorialogs$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a9b33e859e6b003ed6cf791b4289dd72cf232bc3b70450b91f9beda774124d9a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "13a14cbb54c36dd2a407cce1b8a185114c2a04f3a1ae919d1feb28b0098f9c9b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2c91259a80566f5f4d068373b819b8ef0b4d7208da8b34285b6ce3a06adde354"
    sha256 cellar: :any_skip_relocation, sonoma:        "336accf888d2c2ee8071ba2d7bec791f2b915aeaf9a1f6d583b61e1f02929210"
    sha256 cellar: :any_skip_relocation, ventura:       "7d177f044f704e4c3f733a609bb1635e279fdfee94ed7665c33c0960a4e2aaa4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "07ae9a6fc90dd0729b4c74289a917a95b7bcc97263725d7947ac838928f821ec"
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