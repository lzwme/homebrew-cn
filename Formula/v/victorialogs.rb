class Victorialogs < Formula
  desc "Open source user-friendly database for logs from VictoriaMetrics"
  homepage "https:docs.victoriametrics.comvictorialogs"
  url "https:github.comVictoriaMetricsVictoriaMetricsarchiverefstagsv1.4.0-victorialogs.tar.gz"
  sha256 "541b653f54e87b2144b10a62537a39677b97970969602290331ec58094391ffb"
  license "Apache-2.0"

  # There are tags like `pmm-6401-v1.89.1` in the upstream repo. They don't
  # actually represent releases, despite referring to one in the tag name.
  # Make sure we only match the ones using the common format.
  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)[._-]victorialogs$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "94d4053056a144746ffd5f286f0dc4db58d0c6a4dedfd9f9b45ad6f58daf6df2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "00bc933d004c1ef4f3fe88aaf53c79ed91866f240f6dc21fcf63aeda755fd0aa"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bb8b67b471f0b9b32e58d6c92e3421eb4e84af99a42d39df97f00352bbdddf1a"
    sha256 cellar: :any_skip_relocation, sonoma:        "3fc343012db2c16405fae55015baed2dd8ccef78c48eeecbad1b4e63476d393f"
    sha256 cellar: :any_skip_relocation, ventura:       "497fbfd094a8483f3888c0bc4c9e733a46603b1392dbdd0915e35aca84ebdda1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "853f41c88e9a97a302b7fbd6f401285f3a37917694da31adf2ab5a9a0bb5cbf4"
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