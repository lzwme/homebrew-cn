class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https://pocketbase.io/"
  url "https://ghfast.top/https://github.com/pocketbase/pocketbase/archive/refs/tags/v0.32.0.tar.gz"
  sha256 "f8c950c7b67f58a893cde181da85cf2406363782b134e41cabf815e8fbe32d9d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c248c9a318de99a13dfb20ac3890d090039a2088840c64e38a692b22d594c921"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c248c9a318de99a13dfb20ac3890d090039a2088840c64e38a692b22d594c921"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c248c9a318de99a13dfb20ac3890d090039a2088840c64e38a692b22d594c921"
    sha256 cellar: :any_skip_relocation, sonoma:        "00e95d8ec16c32aeac797fa384e9c1b5d45ff107a22d4dc9da28db5f2dbf3a72"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "62d1f0424e0d7981896ac0cd05aa380512ce7686ca0cd7660035ebb8bcbef130"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1fef0d35a4e42a722f947199dfb6016526ba3b88873eefa916e7deb703e6b4d7"
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