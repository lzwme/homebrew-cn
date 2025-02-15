class Victorialogs < Formula
  desc "Open source user-friendly database for logs from VictoriaMetrics"
  homepage "https:docs.victoriametrics.comvictorialogs"
  url "https:github.comVictoriaMetricsVictoriaMetricsarchiverefstagsv1.10.1-victorialogs.tar.gz"
  sha256 "5945f711e93b397bd83265412a96ed468fa21cc500844420aa997a9344c169f8"
  license "Apache-2.0"

  # There are tags like `pmm-6401-v1.89.1` in the upstream repo. They don't
  # actually represent releases, despite referring to one in the tag name.
  # Make sure we only match the ones using the common format.
  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)[._-]victorialogs$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "840f1640f80271dbfa40ce1f6c6ac7cac52e10ac4c21400cca601aa01dea371b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "af79e8ab2af1f20f8a24872815128269b4ce08864c53ee2416bd522a1f3fdb03"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "be85eb886547d2e465c6cfe9f1851bc8392c33a745528fb18b399d47c482d720"
    sha256 cellar: :any_skip_relocation, sonoma:        "ff949dbb2d96bb2e2ea652f4d71ea22fc4b7395517fe5ffdd0e02274962f89af"
    sha256 cellar: :any_skip_relocation, ventura:       "dca90b01792ae9d8d56a0338ea228c90eee4f14cab54d83f85bb6167e3993eff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e41f06cd0c641c8333807846c0ebb50b45a30aaeeb83657155e1b902d35cb9fd"
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