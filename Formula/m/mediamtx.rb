class Mediamtx < Formula
  desc "Zero-dependency real-time media server and media proxy"
  homepage "https:github.combluenvironmediamtx"
  url "https:github.combluenvironmediamtxarchiverefstagsv1.5.0.tar.gz"
  sha256 "c4601244965b8fde036c68c8e31e09c503d057abae72572d4f23239fd47d6702"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c7e2bdded3b278df68d1fd27591c75dd8da351f26cb617df598182e5528ca1ef"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b12001bd1633e92631247732e7260b2d88a62c9a5383a1a3988003241c63b3c3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fd73e4cfa6eda8e132a37a49ffa6dab0b0ab378cc4c47faf300f7d1081d38185"
    sha256 cellar: :any_skip_relocation, sonoma:         "cb1577ecdbd397b4fb6ffc923a3131d4f87286f0fb058d03efb2bfc526a3711a"
    sha256 cellar: :any_skip_relocation, ventura:        "40f27d3475bf3fc3523ca8e57e0bf94334ec8aa7f79805bd4dbc0461a7504771"
    sha256 cellar: :any_skip_relocation, monterey:       "62cf66afc54a9d4e83cfa80220a09b97f700fa358ba1a32aed910440c4c0d5cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f8d77b25a55cba909947bf0ec08176e678041524ccefa437acbc792f6e396c46"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.combluenvironmediamtxinternalcore.version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

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