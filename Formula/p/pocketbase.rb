class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https://pocketbase.io/"
  url "https://ghfast.top/https://github.com/pocketbase/pocketbase/archive/refs/tags/v0.29.1.tar.gz"
  sha256 "936ae39343781a5a357e90d5a3216400988585c36bf4029b94fb5298378fe438"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4f7904cc19b1cd75757c6ab1dc6f9d5e2f1483831dfd2ae3140b7820b1b1042e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4f7904cc19b1cd75757c6ab1dc6f9d5e2f1483831dfd2ae3140b7820b1b1042e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4f7904cc19b1cd75757c6ab1dc6f9d5e2f1483831dfd2ae3140b7820b1b1042e"
    sha256 cellar: :any_skip_relocation, sonoma:        "7a2e08714c8692a928f7403a37429a398758f802f994f7bf08ff43628b27e754"
    sha256 cellar: :any_skip_relocation, ventura:       "7a2e08714c8692a928f7403a37429a398758f802f994f7bf08ff43628b27e754"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1c11cf76c400e7472aeb2635671d5bb11cde86aadc60af4da74ca12c76c8aeab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7cf957d7fc1509956890f0da68f49bae041d6a08e37f26aa8351c0881811db56"
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