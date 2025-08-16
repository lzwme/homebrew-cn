class Tile38 < Formula
  desc "In-memory geolocation data store, spatial index, and realtime geofence"
  homepage "https://tile38.com/"
  url "https://github.com/tidwall/tile38.git",
      tag:      "1.36.0",
      revision: "bbbbabe198d46d4cc13efb8f4ec70064dc7b02c9"
  license "MIT"
  head "https://github.com/tidwall/tile38.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7542cd4794ba5d0d7d69066f72dde9bcc5c061e916829156f41cf1a97b07b7ba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b2573f6756054ebfdffaff47c893643e9d8bf971563b38239dd054b20d862c59"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b4fc23d47a92907760c3581a66dd866577f10aea3a385f698fb54a4af980a61b"
    sha256 cellar: :any_skip_relocation, sonoma:        "79d51f28701233ffd8d867a167870bf977e3930b009ad156de1e928e24fd8af0"
    sha256 cellar: :any_skip_relocation, ventura:       "786c7110493b4c75777757257cc72ffc2716567c65e26d92b81fc605e47e98f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5413d319c4f653374b5283d2a4861614eb9c3f69377bfb37bfbb9721cc554e50"
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
    ]

    system "go", "build", *std_go_args(ldflags:, output: bin/"tile38-server"), "./cmd/tile38-server"
    system "go", "build", *std_go_args(ldflags:, output: bin/"tile38-cli"), "./cmd/tile38-cli"
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
      exec bin/"tile38-server", "-q", "-p", port.to_s
    end
    sleep 2
    # remove `$408` in the first line output
    json_output = shell_output("#{bin}/tile38-cli -p #{port} server")
    tile38_server = JSON.parse(json_output)

    assert_equal tile38_server["ok"], true
    assert_path_exists testpath/"data"
  ensure
    Process.kill("HUP", pid)
  end
end