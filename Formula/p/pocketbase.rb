class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https://pocketbase.io/"
  url "https://ghproxy.com/https://github.com/pocketbase/pocketbase/archive/refs/tags/v0.19.2.tar.gz"
  sha256 "805000d751c10efef47612030f54c35ee86d7e0cb4d4382e1114096df0561f3f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "abd7bd75935b4b205858d70c6071eea6d8956835282cd6ab9529ae495f6c89e4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "abd7bd75935b4b205858d70c6071eea6d8956835282cd6ab9529ae495f6c89e4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "abd7bd75935b4b205858d70c6071eea6d8956835282cd6ab9529ae495f6c89e4"
    sha256 cellar: :any_skip_relocation, sonoma:         "8902ff1bb617043119c6c76fa29fa4ee9dbfa0779f424c0db2fe2b383e66f505"
    sha256 cellar: :any_skip_relocation, ventura:        "8902ff1bb617043119c6c76fa29fa4ee9dbfa0779f424c0db2fe2b383e66f505"
    sha256 cellar: :any_skip_relocation, monterey:       "8902ff1bb617043119c6c76fa29fa4ee9dbfa0779f424c0db2fe2b383e66f505"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4808152432143dcae012599951f6019867732d6f4f5d9ae2f360bb3eac2a448e"
  end

  depends_on "go" => :build

  uses_from_macos "netcat" => :test

  def install
    ENV["CGO_ENABLED"] = "0"

    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/pocketbase/pocketbase.Version=#{version}"), "./examples/base"
  end

  test do
    assert_match "pocketbase version #{version}", shell_output("#{bin}/pocketbase --version")

    port = free_port
    _, _, pid = PTY.spawn("#{bin}/pocketbase serve --dir #{testpath}/pb_data --http 127.0.0.1:#{port}")
    sleep 5

    system "nc", "-z", "localhost", port
    Process.kill "SIGINT", pid

    assert_predicate testpath/"pb_data", :exist?, "pb_data directory should exist"
    assert_predicate testpath/"pb_data", :directory?, "pb_data should be a directory"

    assert_predicate testpath/"pb_data/data.db", :exist?, "pb_data/data.db should exist"
    assert_predicate testpath/"pb_data/data.db", :file?, "pb_data/data.db should be a file"

    assert_predicate testpath/"pb_data/logs.db", :exist?, "pb_data/logs.db should exist"
    assert_predicate testpath/"pb_data/logs.db", :file?, "pb_data/logs.db should be a file"
  end
end