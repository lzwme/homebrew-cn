class Mediamtx < Formula
  desc "Zero-dependency real-time media server and media proxy"
  homepage "https://github.com/bluenviron/mediamtx"
  url "https://ghproxy.com/https://github.com/bluenviron/mediamtx/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "77f2a60eff5e6907127a8ecae4e94bce2209c88119cfb13c2255e003b106659d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3f2789099171ee1353d54b2961b65f0ed79092870b7b16810017d9c9f7bfbe6a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fb55fd00187423d3482b952583963b7b61620e14eb1a12e15c314e2a9f12f337"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d92ef9854286e8e5f55ab700d944aa5d4c001de6b742a8a9b501102f05825199"
    sha256 cellar: :any_skip_relocation, sonoma:         "057ee9b1280e9eb5c4ecb7fc96cce67c23798ccaca09696a7a8b828c1895a93e"
    sha256 cellar: :any_skip_relocation, ventura:        "6998dadf6b57118bc3595eec5cd60bd53b44a35faead8e65185042c3453c5a00"
    sha256 cellar: :any_skip_relocation, monterey:       "b63548cd32b7396ab2f6ebd91c35378a24c39c0d5744b6c804630744eb6ed9ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "15aa05cd2f026511871079143bce0130eb37c1a39238723b49f0184488f89da3"
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