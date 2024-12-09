class Tile38 < Formula
  desc "In-memory geolocation data store, spatial index, and realtime geofence"
  homepage "https:tile38.com"
  url "https:github.comtidwalltile38.git",
      tag:      "1.33.4",
      revision: "72845124ecbac994e545deef17a78f2774232943"
  license "MIT"
  head "https:github.comtidwalltile38.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7f3505867be68f631f3bab82fea26833c0f8d43572348a7341af6f0b5e325628"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7f3505867be68f631f3bab82fea26833c0f8d43572348a7341af6f0b5e325628"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7f3505867be68f631f3bab82fea26833c0f8d43572348a7341af6f0b5e325628"
    sha256 cellar: :any_skip_relocation, sonoma:        "e38a526c9e424bef2580841f7d6e127984d591b133ea55bf68850b7c0562bb81"
    sha256 cellar: :any_skip_relocation, ventura:       "e38a526c9e424bef2580841f7d6e127984d591b133ea55bf68850b7c0562bb81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7f176ff700f17a25d9e979e7e15bef568a66725a56bc82abe2f64d4101cdadaa"
  end

  depends_on "go" => :build

  def datadir
    var"tile38data"
  end

  def install
    ldflags = %W[
      -s -w
      -X github.comtidwalltile38core.Version=#{version}
      -X github.comtidwalltile38core.GitSHA=#{Utils.git_short_head}
    ]

    system "go", "build", *std_go_args(ldflags:, output: bin"tile38-server"), ".cmdtile38-server"
    system "go", "build", *std_go_args(ldflags:, output: bin"tile38-cli"), ".cmdtile38-cli"
  end

  def post_install
    # Make sure the data directory exists
    datadir.mkpath
  end

  def caveats
    <<~EOS
      To connect: tile38-cli
    EOS
  end

  service do
    run [opt_bin"tile38-server", "-d", var"tile38data"]
    keep_alive true
    working_dir var
    log_path var"logtile38.log"
    error_log_path var"logtile38.log"
  end

  test do
    port = free_port
    pid = fork do
      exec bin"tile38-server", "-q", "-p", port.to_s
    end
    sleep 2
    # remove `$408` in the first line output
    json_output = shell_output("#{bin}tile38-cli -p #{port} server")
    tile38_server = JSON.parse(json_output)

    assert_equal tile38_server["ok"], true
    assert_predicate testpath"data", :exist?
  ensure
    Process.kill("HUP", pid)
  end
end