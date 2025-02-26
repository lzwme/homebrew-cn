class Victorialogs < Formula
  desc "Open source user-friendly database for logs from VictoriaMetrics"
  homepage "https:docs.victoriametrics.comvictorialogs"
  url "https:github.comVictoriaMetricsVictoriaMetricsarchiverefstagsv1.14.0-victorialogs.tar.gz"
  sha256 "00c558d3bb725f214e2a6e47ce765c06e5e51bdca9d556a389dae43b2f0094c3"
  license "Apache-2.0"

  # There are tags like `pmm-6401-v1.89.1` in the upstream repo. They don't
  # actually represent releases, despite referring to one in the tag name.
  # Make sure we only match the ones using the common format.
  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)[._-]victorialogs$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b4a1ffbb53bf33f6aec2b6908743cd58a745ffa5c524c194bdf6bcb98339700b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "96e29fcd0cca29a4a67a812d2954f1e1031d8e10711b5bd432439593d368a0f8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b919e5211c02d3899d3c44014db73ecb5fc9d57334494f2a87dfd1416d7b1ffe"
    sha256 cellar: :any_skip_relocation, sonoma:        "2b1cda4be9c56b72bd1360f190fc06a8308b58f8b488affccd9696ffab7bb8e0"
    sha256 cellar: :any_skip_relocation, ventura:       "e89a61d25d8eb2deb96ae90c9faf28abd9430930bfbd247748278df7db6ecd5b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "313e42ce38e16b20c359598b37fb2b212f7b881380ba57e10dd6931d00d28030"
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