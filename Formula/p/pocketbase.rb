class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https://pocketbase.io/"
  url "https://ghfast.top/https://github.com/pocketbase/pocketbase/archive/refs/tags/v0.39.0.tar.gz"
  sha256 "5053263d0c8d58fa0ea67e746bc7506d7f42f1a1e206f68302c33f09f38b4267"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0283a2fc8ec7aace7cc34555dab6eac352ae4cf927493d2525345c09f36ef1a3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0283a2fc8ec7aace7cc34555dab6eac352ae4cf927493d2525345c09f36ef1a3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0283a2fc8ec7aace7cc34555dab6eac352ae4cf927493d2525345c09f36ef1a3"
    sha256 cellar: :any_skip_relocation, sonoma:        "d2e68c529a39168dabd25182f5a69843224207680eae11baae3d32b1d05f90e7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7392afd7413c8c318a32d0b4c5d92cd4c9260d753118b4ad25bf98c9d9cb53b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8d603e61e301cb56a41db80173ccfad9ac0ecb53885c7f80f815d03666f6c215"
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