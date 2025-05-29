class Victorialogs < Formula
  desc "Open source user-friendly database for logs from VictoriaMetrics"
  homepage "https:docs.victoriametrics.comvictorialogs"
  url "https:github.comVictoriaMetricsVictoriaMetricsarchiverefstagsv1.23.0-victorialogs.tar.gz"
  sha256 "ba202448e7572dd62a10a09eacc8be4cfe3cd014026b283a1396f66142e58b04"
  license "Apache-2.0"

  # There are tags like `pmm-6401-v1.89.1` in the upstream repo. They don't
  # actually represent releases, despite referring to one in the tag name.
  # Make sure we only match the ones using the common format.
  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)[._-]victorialogs$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b85b3a12714bcdd3f02cbdf92f66eaeb0b4f0ae839da1df0dbb289f0507d9407"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f6dca5410528c00de1ba6352e0904ed7ce9dc79e9c9fac6149d4553f27660716"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9917cd0ba6bca30031d73e54552fabd72e58ff569fadf5b3fd0da99c9e39bd9a"
    sha256 cellar: :any_skip_relocation, sonoma:        "4fe02ae9a4cc00cc3da50f2c8a8b4c2db714024575bd2d6909bb179e012c870c"
    sha256 cellar: :any_skip_relocation, ventura:       "d6af4608d36fe38baf80b4d77c30c15e29852f7b6e070005a744ed36530fc151"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "800a9a21e653137ba10a1cbce5e3c14dbabdfa9382fb7497e905b21151ee7b9e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9313fda6f4575214a9e8c67aaedbbc13db7ff3d7c38e4915a27b5e18ff46756f"
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