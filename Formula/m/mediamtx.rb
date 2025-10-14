class Mediamtx < Formula
  desc "Zero-dependency real-time media server and media proxy"
  homepage "https://github.com/bluenviron/mediamtx"
  # need to use the tag to generate the version info
  url "https://github.com/bluenviron/mediamtx.git",
      tag:      "v1.15.2",
      revision: "26b6be02db91f4d62d0fbf3be4d06d036a565f2b"
  license "MIT"
  head "https://github.com/bluenviron/mediamtx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "30446a4d38df61c6b500e7f385cdec815117c3727d970e02b93dd788a0b52999"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "30446a4d38df61c6b500e7f385cdec815117c3727d970e02b93dd788a0b52999"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "30446a4d38df61c6b500e7f385cdec815117c3727d970e02b93dd788a0b52999"
    sha256 cellar: :any_skip_relocation, sonoma:        "0b3b80aa58d3a11da916a42817cd28d16e1b7204e715dfbb8183ce968c8f17ef"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7260ff016d703147e50125114aa4f7a143ec5164f470dbcbcd57f3d5dfd0a0db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9adc9a7a495f7a20db2923e4618c31f7c2bc2b21fe04d9096b7626de8c5644aa"
  end

  depends_on "go" => :build

  def install
    system "go", "generate", "./..."
    system "go", "build", *std_go_args(ldflags: "-s -w")

    # Install default config
    (etc/"mediamtx").install "mediamtx.yml"
  end

  def post_install
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
    pid = fork do
      exec({ "MTX_API" => "yes", "MTX_APIADDRESS" => mediamtx_api }, bin/"mediamtx", etc/"mediamtx/mediamtx.yml")
    end
    sleep 3

    # Check API output matches configuration
    curl_output = shell_output("curl --silent http://#{mediamtx_api}/v3/config/global/get")
    assert_match "\"apiAddress\":\"#{mediamtx_api}\"", curl_output
  ensure
    Process.kill("TERM", pid)
    Process.wait pid
  end
end