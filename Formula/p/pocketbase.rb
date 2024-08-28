class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https:pocketbase.io"
  url "https:github.compocketbasepocketbasearchiverefstagsv0.22.20.tar.gz"
  sha256 "6bf7003af949c82f489712598b8300dd611554cc26a49a2730b7c69f5d966ed0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "650a244bd82e255fd39616fcadfb15bab84d698080d980abe209d42080e9c880"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "650a244bd82e255fd39616fcadfb15bab84d698080d980abe209d42080e9c880"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "650a244bd82e255fd39616fcadfb15bab84d698080d980abe209d42080e9c880"
    sha256 cellar: :any_skip_relocation, sonoma:         "e769e6d9c9208a4120a7d23b69297d9216bd64242b7e6348c96bc6d229b624d6"
    sha256 cellar: :any_skip_relocation, ventura:        "e769e6d9c9208a4120a7d23b69297d9216bd64242b7e6348c96bc6d229b624d6"
    sha256 cellar: :any_skip_relocation, monterey:       "e769e6d9c9208a4120a7d23b69297d9216bd64242b7e6348c96bc6d229b624d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2cde62c9e97e5336a91497f02f01f94a1ef119a9db762383fe9ffb21cecaa02c"
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