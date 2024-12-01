class Victorialogs < Formula
  desc "Open source user-friendly database for logs from VictoriaMetrics"
  homepage "https:docs.victoriametrics.comvictorialogs"
  url "https:github.comVictoriaMetricsVictoriaMetricsarchiverefstagsv1.106.1.tar.gz"
  sha256 "e856eda2e9b9351d4a24ccc904a5ad9d70dfb48edf6573d18d49df8976cc37d5"
  license "Apache-2.0"

  # There are tags like `pmm-6401-v1.89.1` in the upstream repo. They don't
  # actually represent releases, despite referring to one in the tag name.
  # Make sure we only match the ones using the common format.
  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "59308bae9011fc0aa0a76ca1570f6d7eb609bf4b5fe95f2955cc713e1ccd3869"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e8dc1da2d9173d4529ebd351f6be9777c3311776bab470ea6ad1956585746276"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d1c5780f5b89a4e1187ccb737028be61b5a9bcca785f6dc49961640be0925f10"
    sha256 cellar: :any_skip_relocation, sonoma:        "549f0bb91f874755f57e9427d0f370e7befdb8c70d7b1b13865798ea7c66b456"
    sha256 cellar: :any_skip_relocation, ventura:       "d3bc33967fe3aebc6750c73a0b2344da3594d499754c8e1b36b1a77839f8681f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d62464311a9f38f47916987366a55250f5a57f11c6aabfbae74b5d1288c4f14b"
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