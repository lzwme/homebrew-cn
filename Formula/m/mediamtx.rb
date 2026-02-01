class Mediamtx < Formula
  desc "Zero-dependency real-time media server and media proxy"
  homepage "https://github.com/bluenviron/mediamtx"
  # need to use the tag to generate the version info
  url "https://github.com/bluenviron/mediamtx.git",
      tag:      "v1.16.0",
      revision: "74eaa11d3a390d897aa84c1ef16d6999b83820fc"
  license "MIT"
  head "https://github.com/bluenviron/mediamtx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "847dd9aa1547841438dfb3d69ec836bd9204662ec86067dfcc56025143ddb1d6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "847dd9aa1547841438dfb3d69ec836bd9204662ec86067dfcc56025143ddb1d6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "847dd9aa1547841438dfb3d69ec836bd9204662ec86067dfcc56025143ddb1d6"
    sha256 cellar: :any_skip_relocation, sonoma:        "4b0e9bf11c69f12974f3cd28c3cd6c4a9620688f02790c96bd6eb425ca2a5d9f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e6db8885bf9cef38f39d7ac56a3d1e401866083b3a3eb95ff2ceb59292f49be3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7e1bbef7254095c44b23a0636e3f38d28178cdfa815fbdbea37249314781aede"
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