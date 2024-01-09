class Mediamtx < Formula
  desc "Zero-dependency real-time media server and media proxy"
  homepage "https:github.combluenvironmediamtx"
  url "https:github.combluenvironmediamtxarchiverefstagsv1.4.2.tar.gz"
  sha256 "4c18419a010fe3ba0a5e230079d84d45e14d824e8a633997ec583dcb7cc56924"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2aa3853e66543ce8a728f83963389dd01c013d00275a9842beb50b4068adf17d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "53513e9028ae19a08b2b35975a448fac81ed101ae93bd6ce4be4e947182cca25"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2db3d2830c637eccf8a3b247b60d88e36ed5f1efe3bde897ae0fc5d7d17c7bcd"
    sha256 cellar: :any_skip_relocation, sonoma:         "c7878259814e5e723acad056e19805973a2ff859b8b6c5dc0121c3e36e6dd3ef"
    sha256 cellar: :any_skip_relocation, ventura:        "af592801cce15cf52eceda57ce72dd7919bcd1e34478bd1f096b04a1d68d43c3"
    sha256 cellar: :any_skip_relocation, monterey:       "cbc289ca5a1253a0346ce47b456c4af60da90a35b9ad0506ef82242b624e7cd3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "89b5f6732e21569ec75e4441ef62eedee855e0d1e9a18305c4fa3ffcc13183b2"
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