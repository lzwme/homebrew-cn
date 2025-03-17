class Victorialogs < Formula
  desc "Open source user-friendly database for logs from VictoriaMetrics"
  homepage "https:docs.victoriametrics.comvictorialogs"
  url "https:github.comVictoriaMetricsVictoriaMetricsarchiverefstagsv1.17.0-victorialogs.tar.gz"
  sha256 "e891e58282ecfcbf3fdeb172152801a35e56b7997f822a27a390d68890937a81"
  license "Apache-2.0"

  # There are tags like `pmm-6401-v1.89.1` in the upstream repo. They don't
  # actually represent releases, despite referring to one in the tag name.
  # Make sure we only match the ones using the common format.
  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)[._-]victorialogs$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "278e2aa75da7441fb68cdaa4bdaf3fd97506e31b4263a456f171b5124bedc0c9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d21ffc4c943d3458c054c2cc4028c09b45074dff324b48c70848660b0bea8598"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8b51442b19990d93cc1e84cfd66d69adf6e15ba2e8a3833fc35d71210ce7f4e6"
    sha256 cellar: :any_skip_relocation, sonoma:        "13124c38257d56358d6fddc8e1e8bc45e1d6eabf84dd36a1d925eea8c1ce0142"
    sha256 cellar: :any_skip_relocation, ventura:       "dd5598c0d574208e9a7be840bfb9f993b9ecc89b5549cbf3a8d01171bc54f8d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "10c53ca53bbd0d634165363a3d689cda159bfc10e416e354d951871e7743794b"
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