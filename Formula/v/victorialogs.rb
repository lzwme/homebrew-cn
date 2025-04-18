class Victorialogs < Formula
  desc "Open source user-friendly database for logs from VictoriaMetrics"
  homepage "https:docs.victoriametrics.comvictorialogs"
  url "https:github.comVictoriaMetricsVictoriaMetricsarchiverefstagsv1.19.0-victorialogs.tar.gz"
  sha256 "3f04d4bf7982a7ac3dcd3a20eb47f67a2ce3b024cf1acac4fdae016474748549"
  license "Apache-2.0"

  # There are tags like `pmm-6401-v1.89.1` in the upstream repo. They don't
  # actually represent releases, despite referring to one in the tag name.
  # Make sure we only match the ones using the common format.
  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)[._-]victorialogs$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "00f278b432865e69f806d7d539e2f455ad8e67fd37c5d03de57ef63acf96ecea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a43a7bbaad497457c55686e59f2135096cd6ae92fb56a8c2004a8ba6d5be487f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e29d11655b35210b70716f700d79507d4a28cdaed81b256d7cd9f469fd88eb4b"
    sha256 cellar: :any_skip_relocation, sonoma:        "7acb36db6036c04d33154c9724d8f31a487aca01b730bfbd79d9111717f19225"
    sha256 cellar: :any_skip_relocation, ventura:       "a4305e2db71ead689e4ce8a15e2a9bacd19f1fea8605723e82e2a4f10aad66af"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a273bfc1923352839cbefbc5b6a25355352ae91c08d84101c55340fe63ca701d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6e0af091ef8fc02bcd22a90ff2bdf841cadc6184e1bdc88742a9ac6a4776a890"
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