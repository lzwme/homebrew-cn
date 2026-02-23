class Mediamtx < Formula
  desc "Zero-dependency real-time media server and media proxy"
  homepage "https://github.com/bluenviron/mediamtx"
  # need to use the tag to generate the version info
  url "https://github.com/bluenviron/mediamtx.git",
      tag:      "v1.16.2",
      revision: "4974cacb940d5e47720fe5dc34afca99ba69c3ab"
  license "MIT"
  head "https://github.com/bluenviron/mediamtx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8de9dd8f926975528485a40eaf544393ca414914ad4d1db0f759fb3687f52523"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8de9dd8f926975528485a40eaf544393ca414914ad4d1db0f759fb3687f52523"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8de9dd8f926975528485a40eaf544393ca414914ad4d1db0f759fb3687f52523"
    sha256 cellar: :any_skip_relocation, sonoma:        "0d0de0a7432434001201f1c72f46c2b05175bc7d16362773ab5da55c53fe3090"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4850d004c9249846eea03f0f3336a4dc29ebfea4dde1c283737fd7618792c0c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aab60035a9f273d37d975c65a4d2dcc9c0f4bdbb8ba813039fbb9419b39384e5"
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