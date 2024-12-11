class Tile38 < Formula
  desc "In-memory geolocation data store, spatial index, and realtime geofence"
  homepage "https:tile38.com"
  url "https:github.comtidwalltile38.git",
      tag:      "1.34.0",
      revision: "5be471ae138305d422a87012756756decc0b9c81"
  license "MIT"
  head "https:github.comtidwalltile38.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2b897dfd9efa1f6b046b5adf054c8798e9cd1ea402ec0a2b09f0c9a3be4c9b1c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2b897dfd9efa1f6b046b5adf054c8798e9cd1ea402ec0a2b09f0c9a3be4c9b1c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2b897dfd9efa1f6b046b5adf054c8798e9cd1ea402ec0a2b09f0c9a3be4c9b1c"
    sha256 cellar: :any_skip_relocation, sonoma:        "1f5d313ca682203a45fc6ebd8f95a992c9a412a2f22390a07f3e3156d8290692"
    sha256 cellar: :any_skip_relocation, ventura:       "1f5d313ca682203a45fc6ebd8f95a992c9a412a2f22390a07f3e3156d8290692"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6ab04657b54a826124e48f681e4d4b6502f40dbfa85420021bc383de6380385b"
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