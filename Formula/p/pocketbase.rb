class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https:pocketbase.io"
  url "https:github.compocketbasepocketbasearchiverefstagsv0.25.5.tar.gz"
  sha256 "d2c1d7c2c2d7d61acc74db5bd993bb4836716e043fc03d49fb3c132c53ab572c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6f84c5c8c8e05c1fbdb2322b4a57c6765c027435c81e7abc7227c9311a2b547a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6f84c5c8c8e05c1fbdb2322b4a57c6765c027435c81e7abc7227c9311a2b547a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6f84c5c8c8e05c1fbdb2322b4a57c6765c027435c81e7abc7227c9311a2b547a"
    sha256 cellar: :any_skip_relocation, sonoma:        "042ec61b073063d7f1e0eff9ddf59ea1a5366f41af86a691b63154c8a9933387"
    sha256 cellar: :any_skip_relocation, ventura:       "042ec61b073063d7f1e0eff9ddf59ea1a5366f41af86a691b63154c8a9933387"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dba94fe319021881df6fc831ee1d79a8c10cb49807fae4c753d4ef53fc41309d"
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

    assert_path_exists testpath"pb_data", "pb_data directory should exist"
    assert_predicate testpath"pb_data", :directory?, "pb_data should be a directory"

    assert_path_exists testpath"pb_datadata.db", "pb_datadata.db should exist"
    assert_predicate testpath"pb_datadata.db", :file?, "pb_datadata.db should be a file"

    assert_path_exists testpath"pb_dataauxiliary.db", "pb_dataauxiliary.db should exist"
    assert_predicate testpath"pb_dataauxiliary.db", :file?, "pb_dataauxiliary.db should be a file"
  ensure
    Process.kill "TERM", pid
  end
end