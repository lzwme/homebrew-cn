class Mediamtx < Formula
  desc "Zero-dependency real-time media server and media proxy"
  homepage "https://github.com/bluenviron/mediamtx"
  url "https://ghproxy.com/https://github.com/bluenviron/mediamtx/archive/refs/tags/v1.3.1.tar.gz"
  sha256 "a844bc95b4b33dadaaeeab2945add83c9c8ca1c6833e0d3d43a82c5c9bb126af"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "aadf15953997213549616d14ff91b8268ca4277afb711505c0835ab8e44feeb5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b3becd9d0d59a5b8b36cdf35142ff172505452a0a8dea8853f0e7214b64961c9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5120b0948dc0ddf2a00f8b83c75e2d55f73617cebd6587a7bf34a011cec348a2"
    sha256 cellar: :any_skip_relocation, sonoma:         "a44857068f9282f9932be7ecbea1a70947e368e402f74501b27e4613c5bf46ea"
    sha256 cellar: :any_skip_relocation, ventura:        "b6468d3f5792e6b8be60870b9bd7de2fda0c902dcc741bbf486de4daea1919de"
    sha256 cellar: :any_skip_relocation, monterey:       "3007beb38ff637ac418b40acaf0ddd70e26c9082a96659e3f92c323a8ff16cb7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8ec8657913150ec8155fad66f70c4b4e92afa2eb8de8db0354143a2a88f210d5"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/bluenviron/mediamtx/internal/core.version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

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
    assert_equal version, shell_output(bin/"mediamtx --version")

    mediamtx_api = "127.0.0.1:#{free_port}"
    mediamtx = fork do
      exec({ "MTX_API" => "yes", "MTX_APIADDRESS" => mediamtx_api }, bin/"mediamtx", etc/"mediamtx/mediamtx.yml")
    end
    sleep 3

    # Check API output matches configuration
    curl_output = shell_output("curl --silent http://#{mediamtx_api}/v3/config/global/get")
    assert_match "\"apiAddress\":\"#{mediamtx_api}\"", curl_output
  ensure
    Process.kill("TERM", mediamtx)
    Process.wait mediamtx
  end
end