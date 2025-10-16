class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https://pocketbase.io/"
  url "https://ghfast.top/https://github.com/pocketbase/pocketbase/archive/refs/tags/v0.30.3.tar.gz"
  sha256 "b8bd23c6fb2e12da5a5cbeaffefb8e7bf0ad1ed7fa10bafc5be49ad4ab571f64"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d0117a7ceb09607ce3f7d7688048e706ca5b134f5eb71aa06d1b05f7e829d2e4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d0117a7ceb09607ce3f7d7688048e706ca5b134f5eb71aa06d1b05f7e829d2e4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d0117a7ceb09607ce3f7d7688048e706ca5b134f5eb71aa06d1b05f7e829d2e4"
    sha256 cellar: :any_skip_relocation, sonoma:        "dd7d6d4bcdd82e504414236f57c6c5b983d137b267ed551ce666cf6dfd75e4a1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "854f4a1ef3e080abd76da16c69a158d55215bb7ddf2d99b927626aa25aaab55c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "acfe84f0f0f99e2ed63efe3c36a541c8021c987cb50dbdad3c75aae07fc6ca15"
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