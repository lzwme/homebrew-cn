class Tile38 < Formula
  desc "In-memory geolocation data store, spatial index, and realtime geofence"
  homepage "https:tile38.com"
  url "https:github.comtidwalltile38.git",
      tag:      "1.33.1",
      revision: "4a1c800b0ec76f924d4b9c21b1ed08948e26e851"
  license "MIT"
  head "https:github.comtidwalltile38.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "91714ae718efda1c232478fa22b53e207b586c8282444c2c07ba50b80500047e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b735caee5eaa8c72d174db450ce94783cdb58c62464aa1c4abad63623e8c4fe5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7ebf9d191a88c074ac4e3cea5d6ab2943d4f437f125f66203ba819abf7629a6a"
    sha256 cellar: :any_skip_relocation, sonoma:         "04e3b4e7e6efaf2c7a99cf3c064949687fa51c0872db9f2981c66efdf0b889e8"
    sha256 cellar: :any_skip_relocation, ventura:        "829aba26354a26671ce9fb619e2626119301649f6c6369e0771d3d246bf3b317"
    sha256 cellar: :any_skip_relocation, monterey:       "99f907328b7454f7a56d14bf6c405d74e9a3b448703f44932216ca0347fab84c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "352537809c80d4aece0eb08e1b8e886b9030a3482c895d23e20524ae8f279590"
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
    ].join(" ")

    system "go", "build", *std_go_args(ldflags:), "-o", bin"tile38-server", ".cmdtile38-server"
    system "go", "build", *std_go_args(ldflags:), "-o", bin"tile38-cli", ".cmdtile38-cli"
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