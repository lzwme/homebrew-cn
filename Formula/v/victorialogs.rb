class Victorialogs < Formula
  desc "Open source user-friendly database for logs from VictoriaMetrics"
  homepage "https:docs.victoriametrics.comvictorialogs"
  url "https:github.comVictoriaMetricsVictoriaMetricsarchiverefstagsv1.13.0-victorialogs.tar.gz"
  sha256 "9ffd532c22f11ae6b8295800a8de8e244a6b99728beffb8247eba490a2a75129"
  license "Apache-2.0"

  # There are tags like `pmm-6401-v1.89.1` in the upstream repo. They don't
  # actually represent releases, despite referring to one in the tag name.
  # Make sure we only match the ones using the common format.
  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)[._-]victorialogs$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f84c08c80caa7be52514cf797721e99e4250baf02213bd4d42442084c00dd8ba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d6e4e808481b683bd24533edd2890cd0e5471b0db75e86a61ef2377492bb1640"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d5d96c2cb122e941b936126464265419936a1d812bf49ad54305dfc0b05bde63"
    sha256 cellar: :any_skip_relocation, sonoma:        "6e6a5a790a7ab872fe9a87fe557d0abe373e7645cc02331e4ea92cd33eb061da"
    sha256 cellar: :any_skip_relocation, ventura:       "137800c3c96f9fbd7a68bc27a0636e20d763d1f93513ed02dcd0ae03e837d3f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7c175f99cd4c92632e1ada2e3de0945fca6d9bf7b893fc5e0ea535719208e3f0"
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