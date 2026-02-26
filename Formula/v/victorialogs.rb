class Victorialogs < Formula
  desc "Open source user-friendly database for logs from VictoriaMetrics"
  homepage "https://docs.victoriametrics.com/victorialogs/"
  url "https://ghfast.top/https://github.com/VictoriaMetrics/VictoriaLogs/archive/refs/tags/v1.47.0.tar.gz"
  sha256 "6b5293d9b154a0c54ea9953bbda3c680db5d52571539d1e722a2464c3a1d8e5a"
  license "Apache-2.0"

  # The Git tags are interspersed with higher versions like 1.118.0, so we check
  # the "latest" release instead of the Git tags.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "57b63ad5be6fb2cd38febce86aab9ddef026918f51e83798eeb4b8bfad2d945b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8240227a1631e6eb251838c650b4a1f743a00f69ab95f04f5657b843d60f449d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6ec05e0efc765171b1a79eea1ab892eb4f05497217f57b2eceab73f1007eaf9e"
    sha256 cellar: :any_skip_relocation, sonoma:        "fc78b8de54a1dd4ca7b48f9957909669ba20fc3c71f7f5a093b1fde17cb85b55"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bcea2272f45e9f873554e46c76a944e756ef8873a02a499bc4ae1e9ece40cdf6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d55d7d7c10fe63281a32bf15d5f1fd526538dd5e0d50a4c59c1d8fa24e35d9c2"
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

    pid = spawn bin/"victoria-logs",
                "-httpListenAddr=127.0.0.1:#{http_port}",
                "-storageDataPath=#{testpath}/victorialogs-data"
    sleep 5
    assert_match "Single-node VictoriaLogs", shell_output("curl -s 127.0.0.1:#{http_port}")

    assert_match version.to_s, shell_output("#{bin}/victoria-logs --version")
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end