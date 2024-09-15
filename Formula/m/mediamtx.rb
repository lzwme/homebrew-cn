class Mediamtx < Formula
  desc "Zero-dependency real-time media server and media proxy"
  homepage "https:github.combluenvironmediamtx"
  url "https:github.combluenvironmediamtxarchiverefstagsv1.9.0.tar.gz"
  sha256 "d7f71098cd9e102444ed711bf036ff9c188430c2fa8df6f8a4197df1a63509ff"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "9ed918a2820902d877351a89da74d896e037b3a27970efcf7e28db4e1736cc3a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "30d05e77c8088b1ef612904fbc430720057603a90f421069716c710d74164d63"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "30d05e77c8088b1ef612904fbc430720057603a90f421069716c710d74164d63"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "30d05e77c8088b1ef612904fbc430720057603a90f421069716c710d74164d63"
    sha256 cellar: :any_skip_relocation, sonoma:         "997327e66f7f9bdc00f9820983114705d87c1fdcb454b706bb31f605b7e6f882"
    sha256 cellar: :any_skip_relocation, ventura:        "997327e66f7f9bdc00f9820983114705d87c1fdcb454b706bb31f605b7e6f882"
    sha256 cellar: :any_skip_relocation, monterey:       "997327e66f7f9bdc00f9820983114705d87c1fdcb454b706bb31f605b7e6f882"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "52a809428679200dcc472deed6a63015f3884df669ee176005f96facaf5222aa"
  end

  depends_on "go" => :build

  def install
    system "go", "generate", "...."

    ldflags = "-s -w -X github.combluenvironmediamtxinternalcore.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

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
    assert_equal version, shell_output(bin"mediamtx --version")

    mediamtx_api = "127.0.0.1:#{free_port}"
    mediamtx = fork do
      exec({ "MTX_API" => "yes", "MTX_APIADDRESS" => mediamtx_api }, bin"mediamtx", etc"mediamtxmediamtx.yml")
    end
    sleep 3

    # Check API output matches configuration
    curl_output = shell_output("curl --silent http:#{mediamtx_api}v3configglobalget")
    assert_match "\"apiAddress\":\"#{mediamtx_api}\"", curl_output
  ensure
    Process.kill("TERM", mediamtx)
    Process.wait mediamtx
  end
end