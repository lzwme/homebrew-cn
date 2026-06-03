class Mediamtx < Formula
  desc "Zero-dependency real-time media server and media proxy"
  homepage "https://github.com/bluenviron/mediamtx"
  # need to use the tag to generate the version info
  url "https://github.com/bluenviron/mediamtx.git",
      tag:      "v1.19.0",
      revision: "b5b63d02fc1c55096cf5a035207d6e5694d1ab4d"
  license "MIT"
  head "https://github.com/bluenviron/mediamtx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c67e4d9fe23dd44f179972b8790ee651674a4d24f0daa04719b24bb032a7e35a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c67e4d9fe23dd44f179972b8790ee651674a4d24f0daa04719b24bb032a7e35a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c67e4d9fe23dd44f179972b8790ee651674a4d24f0daa04719b24bb032a7e35a"
    sha256 cellar: :any_skip_relocation, sonoma:        "de713dcc9a84ce471810ba846c38935be55f7583a69ced50351d3e0c25bf6f6c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dbc63645e6f0124c9a89c3c7897102f5ba491e94bd8eb744f33aedc5456293d9"
    sha256 cellar: :any,                 x86_64_linux:  "2d3914ae83b0db6c73feb7abf68fb94f783a5c26556745644f5ed067c2e70f1f"
  end

  depends_on "go" => :build

  def install
    system "go", "generate", "./..."
    system "go", "build", *std_go_args(ldflags: "-s -w")

    # Install default config
    pkgetc.install "mediamtx.yml"

    (var/"log/mediamtx").mkpath
  end

  service do
    run [opt_bin/"mediamtx", etc/"mediamtx/mediamtx.yml"]
    keep_alive true
    working_dir HOMEBREW_PREFIX
    log_path var/"log/mediamtx/output.log"
    error_log_path var/"log/mediamtx/error.log"
  end

  test do
    port = free_port

    # version report has some issue, https://github.com/bluenviron/mediamtx/issues/3846
    assert_match version.to_s, shell_output("#{bin}/mediamtx --help")

    mediamtx_api = "127.0.0.1:#{port}"
    pid = spawn({ "MTX_API" => "yes", "MTX_APIADDRESS" => mediamtx_api }, bin/"mediamtx", pkgetc/"mediamtx.yml")
    sleep 3

    # Check API output matches configuration
    curl_output = shell_output("curl --silent http://#{mediamtx_api}/v3/config/global/get")
    assert_match "\"apiAddress\":\"#{mediamtx_api}\"", curl_output
  ensure
    Process.kill("TERM", pid)
    Process.wait pid
  end
end