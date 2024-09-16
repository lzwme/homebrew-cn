class Mediamtx < Formula
  desc "Zero-dependency real-time media server and media proxy"
  homepage "https:github.combluenvironmediamtx"
  url "https:github.combluenvironmediamtxarchiverefstagsv1.9.1.tar.gz"
  sha256 "96df7d7dd5362b6971eadcd07d738810d2a3e993ea49b71a7f41c46b43b0a17e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6056b4c005cd636527cc3f13b0da9733fead5457327297d7b2fdd67049900032"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6056b4c005cd636527cc3f13b0da9733fead5457327297d7b2fdd67049900032"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6056b4c005cd636527cc3f13b0da9733fead5457327297d7b2fdd67049900032"
    sha256 cellar: :any_skip_relocation, sonoma:        "bf7d5531989333c810ee2265b8a329b86d76a5015d2ab5b859a3c96a6939037d"
    sha256 cellar: :any_skip_relocation, ventura:       "bf7d5531989333c810ee2265b8a329b86d76a5015d2ab5b859a3c96a6939037d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "50f21e633144e78a1208cd06e2ba5d6e9d19773b717fb47248003b4a3e00fdb8"
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