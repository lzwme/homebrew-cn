class Mediamtx < Formula
  desc "Zero-dependency real-time media server and media proxy"
  homepage "https://mediamtx.org"
  # need to use the tag to generate the version info
  url "https://github.com/bluenviron/mediamtx.git",
      tag:      "v1.20.0",
      revision: "1b943637a4b5778bb929a7af7687b048fecaa03f"
  license "MIT"
  head "https://github.com/bluenviron/mediamtx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4d429d6984b2d485ed229c8475f3b59d2aa9b682d1432a54e187a89d9a529c8e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4d429d6984b2d485ed229c8475f3b59d2aa9b682d1432a54e187a89d9a529c8e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4d429d6984b2d485ed229c8475f3b59d2aa9b682d1432a54e187a89d9a529c8e"
    sha256 cellar: :any_skip_relocation, sonoma:        "83182a19b6cfce3f259cea17a87b76e5825265c7cc208d8f87c7bfd958d46256"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "92c0fe283ca99b07088dc396b0d3236d9236b0bffad51173410746ed03090b40"
    sha256 cellar: :any,                 x86_64_linux:  "e7e20ef8ae4dbebe05ffb6179c03b27291096bc60c1a240a24d9221b7ab9027f"
  end

  depends_on "go" => :build

  def install
    system "go", "generate", "./..."
    system "go", "build", *std_go_args

    # Install default config
    pkgetc.install "mediamtx.yml"
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