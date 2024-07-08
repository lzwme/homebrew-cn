class Mediamtx < Formula
  desc "Zero-dependency real-time media server and media proxy"
  homepage "https:github.combluenvironmediamtx"
  url "https:github.combluenvironmediamtxarchiverefstagsv1.8.4.tar.gz"
  sha256 "e87f8fdb977c7c221f83b3050c6b2a62e459c958de0667b70eac810f9c11d59b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "427681157ca4dc8c1d838f6c7e05f65db666262cf6a8fdab0df4895b7f25c12b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "62bc598c1fb016d23f1e6b830057cee194fadc2388cceaed727b6c9cf40efa5a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9d4c3784c4a120aa6f62154cbba56f5a0835538886419bf47a56348665a99c40"
    sha256 cellar: :any_skip_relocation, sonoma:         "f439910acd4c6fe404fccf7c15ad1b28a36854b27bf4a0f2a89678ee6b926c96"
    sha256 cellar: :any_skip_relocation, ventura:        "54e78691179d9b904004e267bda8b6597d1fa24d4f1a775a6824cbb3f20b509f"
    sha256 cellar: :any_skip_relocation, monterey:       "75e21ec0ebe0a47261e699ae92d478872999a75153df0ea0c8b864b95e8cf9e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3e694f004a77687cc637c2f7f2858671ec002d7bdc9ee62f9cf2bc49265ac19c"
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