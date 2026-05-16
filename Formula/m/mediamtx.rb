class Mediamtx < Formula
  desc "Zero-dependency real-time media server and media proxy"
  homepage "https://github.com/bluenviron/mediamtx"
  # need to use the tag to generate the version info
  url "https://github.com/bluenviron/mediamtx.git",
      tag:      "v1.18.2",
      revision: "c05c14d9afcee5f662c81762eae68f85b36b70d7"
  license "MIT"
  head "https://github.com/bluenviron/mediamtx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0a8f6a15468f6cb962084a43469369c2284d7e2c9417a7996b104efb2d227e52"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0a8f6a15468f6cb962084a43469369c2284d7e2c9417a7996b104efb2d227e52"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0a8f6a15468f6cb962084a43469369c2284d7e2c9417a7996b104efb2d227e52"
    sha256 cellar: :any_skip_relocation, sonoma:        "158e8e1a468f286a31c1ca85de71ba06c41c741659c1e29acbb5872f184ef0f3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3754d11f4c221f442bdf1436401ea768cfe03e23ae60f80040f71e7a5880c166"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fb66c87ea6e6b77348d5c8747f2c68d17a7c7f78f203becc66c45101562bfcdd"
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