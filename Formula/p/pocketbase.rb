class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https:pocketbase.io"
  url "https:github.compocketbasepocketbasearchiverefstagsv0.25.1.tar.gz"
  sha256 "959bd1f82a50dac52ce83d3b915bc1a0ca065c1f307d36a06fd2140b337d2758"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "25b5d2ed69cb538688b6e5b46aaa04b2cd2e5bee90a92c7fbbdf890d5b925614"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "25b5d2ed69cb538688b6e5b46aaa04b2cd2e5bee90a92c7fbbdf890d5b925614"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "25b5d2ed69cb538688b6e5b46aaa04b2cd2e5bee90a92c7fbbdf890d5b925614"
    sha256 cellar: :any_skip_relocation, sonoma:        "c36f22a6893260ba7264572bc8b4e0243f15ff350e438bcb4b6155e0cbfdda90"
    sha256 cellar: :any_skip_relocation, ventura:       "c36f22a6893260ba7264572bc8b4e0243f15ff350e438bcb4b6155e0cbfdda90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8f96e04a75ad3b6655845ea85f00c1155561554f00fc630c777a9fa708c89514"
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