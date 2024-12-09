class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https:pocketbase.io"
  url "https:github.compocketbasepocketbasearchiverefstagsv0.23.5.tar.gz"
  sha256 "c842487b89387c3b5af8108dbd3034fb7e7ed0b3c50ff6fe9b51c1d05b110603"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d598a6580d9c465b2782e5ac6288fc07fc16bf096aca405b71e67c43ccbfdc5b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d598a6580d9c465b2782e5ac6288fc07fc16bf096aca405b71e67c43ccbfdc5b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d598a6580d9c465b2782e5ac6288fc07fc16bf096aca405b71e67c43ccbfdc5b"
    sha256 cellar: :any_skip_relocation, sonoma:        "a02dfb6f7b98e1ac938252f4181672972ae445792f49ea7f6d5153dd44a60df5"
    sha256 cellar: :any_skip_relocation, ventura:       "a02dfb6f7b98e1ac938252f4181672972ae445792f49ea7f6d5153dd44a60df5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dc26fd589f2599d34e5f1b9df33689c4ddf3fab9d27684a531c1e4c3fd165cc1"
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