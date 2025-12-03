class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https://pocketbase.io/"
  url "https://ghfast.top/https://github.com/pocketbase/pocketbase/archive/refs/tags/v0.34.1.tar.gz"
  sha256 "8981dc4cdb06258f7fddb042d628085a4734efa774303a6cb0e59e71dbc11649"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "74640b7ccacccbc28bc9b2eb082cba90d72e4ad154628cf1d762fcede0ee7e67"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "74640b7ccacccbc28bc9b2eb082cba90d72e4ad154628cf1d762fcede0ee7e67"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "74640b7ccacccbc28bc9b2eb082cba90d72e4ad154628cf1d762fcede0ee7e67"
    sha256 cellar: :any_skip_relocation, sonoma:        "9351b85f7b5d28f5eb4a464ad71297471a6040edf43a4aa13c253a84fec984ea"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "31440c6bb241f75a0377392a3f77367903dae078f0ec9878b4898c022f7ffeea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "684c17674502625f1a4430b67ddf3b7d2083900b8e2c896434193e1c13bc0fe7"
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