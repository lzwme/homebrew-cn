class Victorialogs < Formula
  desc "Open source user-friendly database for logs from VictoriaMetrics"
  homepage "https:docs.victoriametrics.comvictorialogs"
  url "https:github.comVictoriaMetricsVictoriaMetricsarchiverefstagsv1.6.0-victorialogs.tar.gz"
  sha256 "2e5066fb797880fe38039920f2d6c4c474fc3c5bf503a6fe2f0fe504a97de3b7"
  license "Apache-2.0"

  # There are tags like `pmm-6401-v1.89.1` in the upstream repo. They don't
  # actually represent releases, despite referring to one in the tag name.
  # Make sure we only match the ones using the common format.
  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)[._-]victorialogs$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "736ed4bfddef6d18829861c10e7fb0d428acdfd3b56e15cb6303844fb808c15f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "29f0fa3298ed7838017eec3df09d42a7141e5cfeb8ddaf40ef4eb3e19016fea9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c80b5cabff60a3405df02a921bff4175656ffa0afe2ccb7d162bb6775b239f81"
    sha256 cellar: :any_skip_relocation, sonoma:        "5f64e8ef6a8f1540153e0c637d95b61e999cc8fb553f0e096d412b7ccaab9da6"
    sha256 cellar: :any_skip_relocation, ventura:       "717dc3bebf9d56382722b3d40a4f33451d2ea49874261b195fd0f53b85a3371b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "866b22f9dd2fed52ffe8460e7a05ac1f23e7d7f54d50c03272206c7a2756cc03"
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