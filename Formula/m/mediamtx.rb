class Mediamtx < Formula
  desc "Zero-dependency real-time media server and media proxy"
  homepage "https://github.com/bluenviron/mediamtx"
  # need to use the tag to generate the version info
  url "https://github.com/bluenviron/mediamtx.git",
      tag:      "v1.13.1",
      revision: "0b901ade3e102fd63d78dc23d7e68c5d7ad04b19"
  license "MIT"
  head "https://github.com/bluenviron/mediamtx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ac74414c98e5cf4b967cfb5046bf4c2e3f6d834fad1e17a9c414750ed81c3f9a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ac74414c98e5cf4b967cfb5046bf4c2e3f6d834fad1e17a9c414750ed81c3f9a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ac74414c98e5cf4b967cfb5046bf4c2e3f6d834fad1e17a9c414750ed81c3f9a"
    sha256 cellar: :any_skip_relocation, sonoma:        "5e9049cad63de61f53cdd34f899f39b04b333418ac7b8cb11f6f41ea3f91c668"
    sha256 cellar: :any_skip_relocation, ventura:       "5e9049cad63de61f53cdd34f899f39b04b333418ac7b8cb11f6f41ea3f91c668"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "961b7c3e7c4d46a7be54768ab75bf049f8c19c9b947248e797099935f9a46943"
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