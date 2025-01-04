class Mediamtx < Formula
  desc "Zero-dependency real-time media server and media proxy"
  homepage "https:github.combluenvironmediamtx"
  # need to use the tag to generate the version info
  url "https:github.combluenvironmediamtx.git",
      tag:      "v1.11.0",
      revision: "21b5031d6b4764f234568a29813c2c56dc9ee8a6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6c349c36d8c7d9a2add46f69312c17b82a5a2a3069b65c580aa9805a38467240"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6c349c36d8c7d9a2add46f69312c17b82a5a2a3069b65c580aa9805a38467240"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6c349c36d8c7d9a2add46f69312c17b82a5a2a3069b65c580aa9805a38467240"
    sha256 cellar: :any_skip_relocation, sonoma:        "b43293444d151d90cc87e0a1c9c4ed4317a1a533354c6199a9cd519ceb7a2722"
    sha256 cellar: :any_skip_relocation, ventura:       "b43293444d151d90cc87e0a1c9c4ed4317a1a533354c6199a9cd519ceb7a2722"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e1dd216cc96f605346d3559df9a56dda2fee05d05b91620fbb3ecefdfdc85d06"
  end

  depends_on "go" => :build

  def install
    system "go", "generate", "...."
    system "go", "build", *std_go_args(ldflags: "-s -w")

    # Install default config
    (etc"mediamtx").install "mediamtx.yml"
  end

  def post_install
    (var"logmediamtx").mkpath
  end

  service do
    run [opt_bin"mediamtx", etc"mediamtxmediamtx.yml"]
    keep_alive true
    working_dir HOMEBREW_PREFIX
    log_path var"logmediamtxoutput.log"
    error_log_path var"logmediamtxerror.log"
  end

  test do
    port = free_port

    # version report has some issue, https:github.combluenvironmediamtxissues3846
    assert_match version.to_s, shell_output("#{bin}mediamtx --help")

    mediamtx_api = "127.0.0.1:#{port}"
    pid = fork do
      exec({ "MTX_API" => "yes", "MTX_APIADDRESS" => mediamtx_api }, bin"mediamtx", etc"mediamtxmediamtx.yml")
    end
    sleep 3

    # Check API output matches configuration
    curl_output = shell_output("curl --silent http:#{mediamtx_api}v3configglobalget")
    assert_match "\"apiAddress\":\"#{mediamtx_api}\"", curl_output
  ensure
    Process.kill("TERM", pid)
    Process.wait pid
  end
end