class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https://pocketbase.io/"
  url "https://ghfast.top/https://github.com/pocketbase/pocketbase/archive/refs/tags/v0.39.5.tar.gz"
  sha256 "1cba4cfeabdbc7fd18c8c748827a0c379ef645989c3c504b805ba996b65925dc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d11cd8d2720446103b3d53a8cc322dffa148a891eafaefae563eb4cd05dbd825"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d11cd8d2720446103b3d53a8cc322dffa148a891eafaefae563eb4cd05dbd825"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d11cd8d2720446103b3d53a8cc322dffa148a891eafaefae563eb4cd05dbd825"
    sha256 cellar: :any_skip_relocation, sonoma:        "29043ba91db9d55a1d2b83df33bc7266895e1eb58b8578f61d6a701c1541d4f5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "910ffc8c39eaafc0f677fe276b0a6b5159bb356c449397639170dad88dec1f70"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "389a11c08a74bd3b8f02e5d9009a96aea13c8edd3b19700edecbe4122b79f9b1"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"

    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/pocketbase/pocketbase.Version=#{version}"), "./examples/base"
  end

  test do
    assert_match "pocketbase version #{version}", shell_output("#{bin}/pocketbase --version")

    port = free_port
    PTY.spawn("#{bin}/pocketbase serve --dir #{testpath}/pb_data --http 127.0.0.1:#{port}") do |_, _, pid|
      sleep 5

      assert_match "API is healthy", shell_output("curl -s http://localhost:#{port}/api/health")

      assert_path_exists testpath/"pb_data", "pb_data directory should exist"
      assert_predicate testpath/"pb_data", :directory?, "pb_data should be a directory"

      assert_path_exists testpath/"pb_data/data.db", "pb_data/data.db should exist"
      assert_predicate testpath/"pb_data/data.db", :file?, "pb_data/data.db should be a file"

      assert_path_exists testpath/"pb_data/auxiliary.db", "pb_data/auxiliary.db should exist"
      assert_predicate testpath/"pb_data/auxiliary.db", :file?, "pb_data/auxiliary.db should be a file"
    ensure
      Process.kill "TERM", pid
    end
  end
end