class Mediamtx < Formula
  desc "Zero-dependency real-time media server and media proxy"
  homepage "https:github.combluenvironmediamtx"
  url "https:github.combluenvironmediamtxarchiverefstagsv1.8.2.tar.gz"
  sha256 "0867c6bd4762adfeadcf94c918861a28495f845dac9b88fe7c63fe4eeecf9d6c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dbd4b1d52323c76d067e29ec5781917594fe847404ad0d657e14190f5f0b35dd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ad7ec2fb08f66453a2d681793a98dbebf5fdd7c9a5ad976c57a50337bc6c95b4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8ed168031eba474b84f6dc00ddb032ddd8564a5c839d80c82694b313ccbb4af4"
    sha256 cellar: :any_skip_relocation, sonoma:         "75e43524787a33d5217bc6a8f38f6c77e5d088368e122c5774632d8fab9cf6ca"
    sha256 cellar: :any_skip_relocation, ventura:        "9511e5a3c805e0c755f5f1e7d37ee63719721ca57458ee1b8344c4f8ddc880de"
    sha256 cellar: :any_skip_relocation, monterey:       "adbcf3cee3ba808cc08472fd869178544b437e7c2a57b86ed7f786b5f816cd49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8bf1a4f4de0007855785cbcb20d7acdb596d5b8137f9bde6d99b287a06fa752c"
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