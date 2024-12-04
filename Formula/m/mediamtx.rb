class Mediamtx < Formula
  desc "Zero-dependency real-time media server and media proxy"
  homepage "https:github.combluenvironmediamtx"
  # need to use the tag to generate the version info
  url "https:github.combluenvironmediamtx.git",
      tag:      "v1.10.0",
      revision: "212382ed2ffc64e318afd36a1206b8f58842c457"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6e586196a828d68d2b36cad31efc044c802130ef267945dde3f6d3e547b7cdfa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6e586196a828d68d2b36cad31efc044c802130ef267945dde3f6d3e547b7cdfa"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6e586196a828d68d2b36cad31efc044c802130ef267945dde3f6d3e547b7cdfa"
    sha256 cellar: :any_skip_relocation, sonoma:        "17eab3d6b717b6fb4b142515ce28011d733c4d1d7473e052236d69ab97c14962"
    sha256 cellar: :any_skip_relocation, ventura:       "17eab3d6b717b6fb4b142515ce28011d733c4d1d7473e052236d69ab97c14962"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "66d8e24a29d6ba2916d6278d551dd66b7e14fbb020f679729de7ff1a25c218aa"
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