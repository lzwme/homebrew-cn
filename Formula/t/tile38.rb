class Tile38 < Formula
  desc "In-memory geolocation data store, spatial index, and realtime geofence"
  homepage "https://tile38.com/"
  url "https://github.com/tidwall/tile38.git",
      tag:      "1.32.1",
      revision: "c494fe5459f7040a1595fc0913f7f54e932a6201"
  license "MIT"
  head "https://github.com/tidwall/tile38.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6686165c300f0116f67190bbe5b6944b04a2a10e242a3b036486095e5a4410b5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "078f8ac5bd0b52d003425282aec19d55f3fb77554796a216f919b8859fa86db9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fc71d141d9f3ede38754d66cff90b481333a1ed0b76aac39e9d7cbf036e48e9f"
    sha256 cellar: :any_skip_relocation, sonoma:         "00868486ff9eeed8c3ff3a2236e4a75a3d5394a6ee9f6c08f336a26883b337d6"
    sha256 cellar: :any_skip_relocation, ventura:        "aa74cc2666af3a94e598b821d6bc563d6af6594c41722d0be533e7ba24300941"
    sha256 cellar: :any_skip_relocation, monterey:       "d3b4ef2d9a0574b3566b6a1c9f9898e447c224533b1c2ccfa6bedb8906422727"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8f569ba570218d0256e3c17014c66543321eed0ef12646c9b09f1afb2462863e"
  end

  depends_on "go" => :build

  def datadir
    var/"tile38/data"
  end

  def install
    ldflags = %W[
      -s -w
      -X github.com/tidwall/tile38/core.Version=#{version}
      -X github.com/tidwall/tile38/core.GitSHA=#{Utils.git_short_head}
    ].join(" ")

    system "go", "build", *std_go_args(ldflags: ldflags), "-o", bin/"tile38-server", "./cmd/tile38-server"
    system "go", "build", *std_go_args(ldflags: ldflags), "-o", bin/"tile38-cli", "./cmd/tile38-cli"
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
    run [opt_bin/"tile38-server", "-d", var/"tile38/data"]
    keep_alive true
    working_dir var
    log_path var/"log/tile38.log"
    error_log_path var/"log/tile38.log"
  end

  test do
    port = free_port
    pid = fork do
      exec "#{bin}/tile38-server", "-q", "-p", port.to_s
    end
    sleep 2
    # remove `$408` in the first line output
    json_output = shell_output("#{bin}/tile38-cli -p #{port} server")
    tile38_server = JSON.parse(json_output)

    assert_equal tile38_server["ok"], true
    assert_predicate testpath/"data", :exist?
  ensure
    Process.kill("HUP", pid)
  end
end