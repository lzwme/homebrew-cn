class Mediamtx < Formula
  desc "Zero-dependency real-time media server and media proxy"
  homepage "https://mediamtx.org"
  # need to use the tag to generate the version info
  url "https://github.com/bluenviron/mediamtx.git",
      tag:      "v1.19.3",
      revision: "5ccc80ad7b1609330a4c397c51a7e701f963d74f"
  license "MIT"
  head "https://github.com/bluenviron/mediamtx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9f359473d26c09a302e4167f90064588299aa69f920b9ec542886d4dd717c320"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9f359473d26c09a302e4167f90064588299aa69f920b9ec542886d4dd717c320"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9f359473d26c09a302e4167f90064588299aa69f920b9ec542886d4dd717c320"
    sha256 cellar: :any_skip_relocation, sonoma:        "ce29c9233994f866223da07762ba939da9ded6e0f1c71ee5df2649f849eba2f1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aeec3da76f1dd8bce3309ec493222549255c9640333eb9fa16dc625ace36311f"
    sha256 cellar: :any,                 x86_64_linux:  "f54a77f4b90705da2152faf1510c32c4b1b7a8037f5d651c1fb62ab0c9f5c214"
  end

  depends_on "go" => :build

  def install
    system "go", "generate", "./..."
    system "go", "build", *std_go_args(ldflags: "-s -w")

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