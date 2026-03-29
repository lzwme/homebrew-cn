class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https://pocketbase.io/"
  url "https://ghfast.top/https://github.com/pocketbase/pocketbase/archive/refs/tags/v0.36.8.tar.gz"
  sha256 "c0f91bac789bffe64f8bf3afd89e74b35f4ba3146431c34daed83e0a458abcc9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1351166d9e5cd91693b7c5de9d091994ed1988fd2a08c6aeb9b8a4805956c019"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1351166d9e5cd91693b7c5de9d091994ed1988fd2a08c6aeb9b8a4805956c019"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1351166d9e5cd91693b7c5de9d091994ed1988fd2a08c6aeb9b8a4805956c019"
    sha256 cellar: :any_skip_relocation, sonoma:        "368262b44e8bc3af5f720763fc87857fcda8aa9e4de2212bd8446885c968260c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3d842ffd782157a8a0a3e6efe0f8203e496621105266adf525b5a7e0458e5dac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "78b79be406a34b99b6d12bb720c163eeca4dd7dc393d3a43a105dd6b82f0f689"
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