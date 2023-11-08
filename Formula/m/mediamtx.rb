class Mediamtx < Formula
  desc "Zero-dependency real-time media server and media proxy"
  homepage "https://github.com/bluenviron/mediamtx"
  url "https://ghproxy.com/https://github.com/bluenviron/mediamtx/archive/refs/tags/v1.2.1.tar.gz"
  sha256 "222553dada1947877867ffeb1f93aaa1e29c13dc2d64a1ba924693ca52f0a404"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f0530b1886c8635914cf91ff5a3596b0a9f4c09c44ac021bdcb66213369a1caa"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dc116fd53cb9295f79f1bfb63b00af57fcb5902d53c7bcde5197b955921ea536"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "87bfdc2e7a716f5fb127073cb23db0df28b5118291e95eaa5c8f28901651caea"
    sha256 cellar: :any_skip_relocation, sonoma:         "091216325278355fbc228af05ebd94dc9ef9cdf5170d1e30717c546e37b1db84"
    sha256 cellar: :any_skip_relocation, ventura:        "4af068cede136671393cc86b8fe740d729c86dbb87b13eb9a8fe79c3a35f32ba"
    sha256 cellar: :any_skip_relocation, monterey:       "484298cb596dedf22b9f14bc4d9cd377bba761eeb4a820bfead46c4830b7c872"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "410b27e61674a1be8193cfe85dc399e41d8c1e56cb2f01f7af271434bceb10d1"
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