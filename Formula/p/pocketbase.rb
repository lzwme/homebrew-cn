class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https:pocketbase.io"
  url "https:github.compocketbasepocketbasearchiverefstagsv0.23.4.tar.gz"
  sha256 "48486d51922cb32fdbbcca7283b61380c03b8c09c3578b75ecf9e2fb8977b4c7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "471f5bb80b0c70086663cc942106eb7d2a5dcb5f1936fd5ed5ddbdbbf0b42b2a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "471f5bb80b0c70086663cc942106eb7d2a5dcb5f1936fd5ed5ddbdbbf0b42b2a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "471f5bb80b0c70086663cc942106eb7d2a5dcb5f1936fd5ed5ddbdbbf0b42b2a"
    sha256 cellar: :any_skip_relocation, sonoma:        "37ae42bcbfaca5ef6b30f45f51428d743d26c8cfe16e8cc842adcd4f91918d92"
    sha256 cellar: :any_skip_relocation, ventura:       "37ae42bcbfaca5ef6b30f45f51428d743d26c8cfe16e8cc842adcd4f91918d92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a2e24b4d63f0aa83d01229d3dd1219dd0ca1f7cf556d6d806192ce07e36f41ca"
  end

  depends_on "go" => :build

  uses_from_macos "netcat" => :test

  def install
    ENV["CGO_ENABLED"] = "0"

    system "go", "build", *std_go_args(ldflags: "-s -w -X github.compocketbasepocketbase.Version=#{version}"), ".examplesbase"
  end

  test do
    assert_match "pocketbase version #{version}", shell_output("#{bin}pocketbase --version")

    port = free_port
    _, _, pid = PTY.spawn("#{bin}pocketbase serve --dir #{testpath}pb_data --http 127.0.0.1:#{port}")
    sleep 5

    system "nc", "-z", "localhost", port

    assert_predicate testpath"pb_data", :exist?, "pb_data directory should exist"
    assert_predicate testpath"pb_data", :directory?, "pb_data should be a directory"

    assert_predicate testpath"pb_datadata.db", :exist?, "pb_datadata.db should exist"
    assert_predicate testpath"pb_datadata.db", :file?, "pb_datadata.db should be a file"

    assert_predicate testpath"pb_dataauxiliary.db", :exist?, "pb_dataauxiliary.db should exist"
    assert_predicate testpath"pb_dataauxiliary.db", :file?, "pb_dataauxiliary.db should be a file"
  ensure
    Process.kill "TERM", pid
  end
end