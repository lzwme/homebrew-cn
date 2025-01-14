class Victorialogs < Formula
  desc "Open source user-friendly database for logs from VictoriaMetrics"
  homepage "https:docs.victoriametrics.comvictorialogs"
  url "https:github.comVictoriaMetricsVictoriaMetricsarchiverefstagsv1.5.0-victorialogs.tar.gz"
  sha256 "c6e3456d6819c23e923e7d9a884e1af6598480553308a05445499de31536a224"
  license "Apache-2.0"

  # There are tags like `pmm-6401-v1.89.1` in the upstream repo. They don't
  # actually represent releases, despite referring to one in the tag name.
  # Make sure we only match the ones using the common format.
  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)[._-]victorialogs$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "99d540e857fb5ba9f6c8c29b567fff392d34192f34c17ab7e0ad8baea1e0e0b9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d53253f79797c1e35d68c6cf7f4b8d77850c20c261175b9645a86f4ede376651"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2ffff0289b64dbd44d345da3937dfe9cabc1e19a56a010a99080d2d2d6c0372e"
    sha256 cellar: :any_skip_relocation, sonoma:        "2cdcae362e5dcbeaefac0bdb5ee6323456b65f40324f80b5f78e3cdd886b3919"
    sha256 cellar: :any_skip_relocation, ventura:       "f1e1d86ec2e1d683d97d221c6dada8d5cac377d6f710b6a89760e6f016c3e5d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "91c29cfdbbef98397877231f4e9f4caa7adf06b621d5a187881f4a3199dd6603"
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