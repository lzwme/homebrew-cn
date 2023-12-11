class Mediamtx < Formula
  desc "Zero-dependency real-time media server and media proxy"
  homepage "https://github.com/bluenviron/mediamtx"
  url "https://ghproxy.com/https://github.com/bluenviron/mediamtx/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "8360d5e0337df599efb7a4200956caf59870965019140f976aba53673e81dc50"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f9f811b29fe6ac712da21da7c9fde8b0234d9cb009a63d179e13bbbef983e21c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ad1ceef24f80133eb00a7ca8b34072e1426aa07558de02701c91e43e8101b6fb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cd466d69fc12a0e708a3612972194daf61c0486f11730cbfe649ec142ef6a819"
    sha256 cellar: :any_skip_relocation, sonoma:         "dbecab875c3acd86fdcc663e218ea3241b30a372a7b3b1e7cbda567a7cc620aa"
    sha256 cellar: :any_skip_relocation, ventura:        "d497b80b45e6c1e59e50b4c6b71e675a7527e016eeea6d1b8771ef68c0ca50d6"
    sha256 cellar: :any_skip_relocation, monterey:       "ab3594f63fbf8fc2abda830927b7da5da6ec2544d4091c54d0ef972d6ca15c8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "932e499ac43579045e4b13eb4fd52c44573b642a33d9a0291ee298a9d7173056"
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