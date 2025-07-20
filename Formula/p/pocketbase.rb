class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https://pocketbase.io/"
  url "https://ghfast.top/https://github.com/pocketbase/pocketbase/archive/refs/tags/v0.29.0.tar.gz"
  sha256 "e0fef0f378247bf04863de72592a30b6b20c14a4033886b9560fe20b0e74b71d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "26ab4307fa85f4d5efbe5ab720f9978211a7d84b97e793d57f3f2169afec68e0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "26ab4307fa85f4d5efbe5ab720f9978211a7d84b97e793d57f3f2169afec68e0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "26ab4307fa85f4d5efbe5ab720f9978211a7d84b97e793d57f3f2169afec68e0"
    sha256 cellar: :any_skip_relocation, sonoma:        "3fd0a2b2c96d87527be8dedbaa55c410ff2cab9cb339feb2a95e107713b3b4f0"
    sha256 cellar: :any_skip_relocation, ventura:       "3fd0a2b2c96d87527be8dedbaa55c410ff2cab9cb339feb2a95e107713b3b4f0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7fa748a742825f3041f04b2559c538eeada6854f31ddade47399c9438bf0b987"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ba6eb14889c37541577770ca548d6ff599b6e24fabe6342dc308bce96d58563f"
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