class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https://pocketbase.io/"
  url "https://ghfast.top/https://github.com/pocketbase/pocketbase/archive/refs/tags/v0.37.5.tar.gz"
  sha256 "2d44e9d390f92dc1919bfd101c538e28e3890d4e640fe2540c3fb3920eed8496"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d30ef3d9cd63a9152bad854ea144c8c3fdcc5d73c12822cc19b9bf986566278f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d30ef3d9cd63a9152bad854ea144c8c3fdcc5d73c12822cc19b9bf986566278f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d30ef3d9cd63a9152bad854ea144c8c3fdcc5d73c12822cc19b9bf986566278f"
    sha256 cellar: :any_skip_relocation, sonoma:        "9caad878842c25f79bed9e38f5223d63ed30bd93ca556e437fc74440c45270e1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "968089de5be664b67758e4918c0b8692de7aaece116e1327486f8f27b26deb64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eaa72bfecc6389219374a96a8abf3829ba77e47f63242c73583e2889aee36397"
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