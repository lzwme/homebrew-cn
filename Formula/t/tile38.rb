class Tile38 < Formula
  desc "In-memory geolocation data store, spatial index, and realtime geofence"
  homepage "https://tile38.com/"
  url "https://github.com/tidwall/tile38.git",
      tag:      "1.36.1",
      revision: "6b98734c7f25a9b9ac3603d715804322969f0f2c"
  license "MIT"
  head "https://github.com/tidwall/tile38.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "57b09e210022f656637a5b76a30e25140f1740b7b0cae29b745f8bb0bdae9245"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "19978292744ceb05749ef080b1151bb8870092790d12da0697605af60b4d558b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e767701f70b5d6bfa176d00b1958e441a569670e1177639e30b644e68f2eb6bc"
    sha256 cellar: :any_skip_relocation, sonoma:        "a289a874e130251ef920d64fc86983c88c421d24493d29601b5b9ecbcc18a851"
    sha256 cellar: :any_skip_relocation, ventura:       "9273845c7a1d94e97905beec05dbad26cfbc4985ee23c007019ada6848a4e98d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "26f0e268d9e08457049937d0fd9f1f7e0385a229a2e54a16ab3e0a55eb364269"
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