class Victorialogs < Formula
  desc "Open source user-friendly database for logs from VictoriaMetrics"
  homepage "https://docs.victoriametrics.com/victorialogs/"
  url "https://ghfast.top/https://github.com/VictoriaMetrics/VictoriaLogs/archive/refs/tags/v1.40.0.tar.gz"
  sha256 "71c25d47205849240ca835ba0327e3ab8ce287a1937a370c470f697c8acda4a5"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5c914009a8b1d4f8b222cc12509cc585b4eebc4bf05fe771ec984b864be219ce"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d01233abe7f96d75b3b26e9d6605b68053c8818e952ecf97e22bd9aa7befcf29"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "16d41a8baa65431c09390cc23838d6647ba734d4c20513a22bba2719b346523e"
    sha256 cellar: :any_skip_relocation, sonoma:        "88caf78882e8c1caf0119c1a50955be4e1ecfad6a5c7a091c17373065faea6bc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f3a7fbd93c3c45f6018cfb9c297a1e3d7e9ef9aa94724c82928d299628694985"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6d9280f65770ca90d68d5e1d4730623f477f6d8ae7023e11f3a3c55454b0fb4c"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/VictoriaMetrics/VictoriaMetrics/lib/buildinfo.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"victoria-logs"), "./app/victoria-logs"
  end

  service do
    run [
      opt_bin/"victoria-logs",
      "-httpListenAddr=127.0.0.1:9428",
      "-storageDataPath=#{var}/victorialogs-data",
    ]
    keep_alive false
    log_path var/"log/victoria-logs.log"
    error_log_path var/"log/victoria-logs.err.log"
  end

  test do
    http_port = free_port

    pid = fork do
      exec bin/"victoria-logs",
        "-httpListenAddr=127.0.0.1:#{http_port}",
        "-storageDataPath=#{testpath}/victorialogs-data"
    end
    sleep 5
    assert_match "Single-node VictoriaLogs", shell_output("curl -s 127.0.0.1:#{http_port}")

    assert_match version.to_s, shell_output("#{bin}/victoria-logs --version")
  ensure
    Process.kill(9, pid)
    Process.wait(pid)
  end
end