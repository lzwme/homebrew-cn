class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https://pocketbase.io/"
  url "https://ghfast.top/https://github.com/pocketbase/pocketbase/archive/refs/tags/v0.40.3.tar.gz"
  sha256 "b04d0eb802197ee8cf27adf207ed2f6fe032ddabe0752913a0e34f02cf897666"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "fd9e1b0d7fb51241f777a3bd9c0fdcb82e7c94a49c4d5377d6f2492b5b8002f1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "fd9e1b0d7fb51241f777a3bd9c0fdcb82e7c94a49c4d5377d6f2492b5b8002f1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "fd9e1b0d7fb51241f777a3bd9c0fdcb82e7c94a49c4d5377d6f2492b5b8002f1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "fd9e1b0d7fb51241f777a3bd9c0fdcb82e7c94a49c4d5377d6f2492b5b8002f1"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "89c4dd0e09716b99c64cba1065fc2be4c45b138c81c8991d0fbbcf03384c6bce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "aa272394b1425104edd3459f72efab6fd81c8de8ef858c2b911528b7bcdefcb0"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"

    system "go", "build", *std_go_args(ldflags: "-X github.com/pocketbase/pocketbase.Version=#{version}"), "./examples/base"
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