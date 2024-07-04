class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https:pocketbase.io"
  url "https:github.compocketbasepocketbasearchiverefstagsv0.22.15.tar.gz"
  sha256 "2ca621ca16c52886c13d0b4ef9be537735bbdb314793c804178922eabbebebbd"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a38970a83974fcee04c344f496ae9de275591ed909fe5d3548f7974954d2af09"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a38970a83974fcee04c344f496ae9de275591ed909fe5d3548f7974954d2af09"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a38970a83974fcee04c344f496ae9de275591ed909fe5d3548f7974954d2af09"
    sha256 cellar: :any_skip_relocation, sonoma:         "c4ad231025c98bfb47d06a6463aec1a98161ea0c21de7bd460a3d2f6825dc2f8"
    sha256 cellar: :any_skip_relocation, ventura:        "c4ad231025c98bfb47d06a6463aec1a98161ea0c21de7bd460a3d2f6825dc2f8"
    sha256 cellar: :any_skip_relocation, monterey:       "c4ad231025c98bfb47d06a6463aec1a98161ea0c21de7bd460a3d2f6825dc2f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "293864262717051ac685bf0bbdd46066c0de5ed2124b87c3e2c96589d8a049cb"
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
    Process.kill "SIGINT", pid

    assert_predicate testpath"pb_data", :exist?, "pb_data directory should exist"
    assert_predicate testpath"pb_data", :directory?, "pb_data should be a directory"

    assert_predicate testpath"pb_datadata.db", :exist?, "pb_datadata.db should exist"
    assert_predicate testpath"pb_datadata.db", :file?, "pb_datadata.db should be a file"

    assert_predicate testpath"pb_datalogs.db", :exist?, "pb_datalogs.db should exist"
    assert_predicate testpath"pb_datalogs.db", :file?, "pb_datalogs.db should be a file"
  end
end