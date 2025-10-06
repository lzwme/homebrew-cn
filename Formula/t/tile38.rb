class Tile38 < Formula
  desc "In-memory geolocation data store, spatial index, and realtime geofence"
  homepage "https://tile38.com/"
  url "https://github.com/tidwall/tile38.git",
      tag:      "1.36.5",
      revision: "0b31bf10dfcfcbe1044a2e74e86a7e40cd72f82d"
  license "MIT"
  head "https://github.com/tidwall/tile38.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6c9990718f67497f27822a55596c07bf0c4ee56309e32716133d15b6f8278d25"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ee88a236bf68b49cdfb2543dc88eb95fae293be156b07de8060dbebe107053b7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "03f270ec38f4b69a51bf8b77db658937c01b805c289589b6dc7e23ed68c2e609"
    sha256 cellar: :any_skip_relocation, sonoma:        "1f0498da1366d75037f12a3f4e2405c496d062930f0b57ef4b2afb230d1f0ddf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c166d5307e57710adfbb4ee57c42eac71e5f6771b60b02b154ff7fdc563a8568"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c89546c235af2ab22636fd440fde5344e121d36f458ece74a0589601006c8dc0"
  end

  depends_on "go" => :build

  def datadir
    var/"tile38/data"
  end

  def install
    ENV["CGO_ENABLED"] = "0" if OS.linux? && Hardware::CPU.arm?

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