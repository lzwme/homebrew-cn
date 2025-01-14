class Mediamtx < Formula
  desc "Zero-dependency real-time media server and media proxy"
  homepage "https:github.combluenvironmediamtx"
  # need to use the tag to generate the version info
  url "https:github.combluenvironmediamtx.git",
      tag:      "v1.11.1",
      revision: "a8d1908789dcbb9a926d36eef7d4e973806f6c51"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "263142d7403f8ad0cf6addfdb17ed2385c2d9876dc237fd747d061b82533ee97"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "263142d7403f8ad0cf6addfdb17ed2385c2d9876dc237fd747d061b82533ee97"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "263142d7403f8ad0cf6addfdb17ed2385c2d9876dc237fd747d061b82533ee97"
    sha256 cellar: :any_skip_relocation, sonoma:        "1c64b5009b1e1466022311182d476564291aafd27b7a590465ab2109dd66bc33"
    sha256 cellar: :any_skip_relocation, ventura:       "1c64b5009b1e1466022311182d476564291aafd27b7a590465ab2109dd66bc33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "73d5ca68acacfe5b634e580c010ee911a9fc66842022b145aaf473c1108146fd"
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