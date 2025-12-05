class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https://pocketbase.io/"
  url "https://ghfast.top/https://github.com/pocketbase/pocketbase/archive/refs/tags/v0.34.2.tar.gz"
  sha256 "85ebfae07d10d086ca7ea59029b06a3e6b8ce2a6630e15c7d8cfcc358c76c34a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6eeb11b07b0d97ca5d9d3dfcbe9330d2ed9e2d2d2c3ca4eb48080b4851f3dee5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6eeb11b07b0d97ca5d9d3dfcbe9330d2ed9e2d2d2c3ca4eb48080b4851f3dee5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6eeb11b07b0d97ca5d9d3dfcbe9330d2ed9e2d2d2c3ca4eb48080b4851f3dee5"
    sha256 cellar: :any_skip_relocation, sonoma:        "a6f5d999aea0218f1280f3a0ac029a8e18a5d9375f9f036a45b02607eda93f42"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "89fb0afd658371b24e9d341bed6825d985ed93e23235e8ac70302c3e04ddc62e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f51436a7e6e370e9cf7a4170dd388f0cd11f9bd700a3d1b60db7ad9a8e4fd3e1"
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