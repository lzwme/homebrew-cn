class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https://pocketbase.io/"
  url "https://ghfast.top/https://github.com/pocketbase/pocketbase/archive/refs/tags/v0.30.4.tar.gz"
  sha256 "326cf38298744a6a7609589d1391ea46514ea03c7ddfb0c4f1c2a378d633eb57"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dfdbd624efd49f7b680b81e8eee60ec3b920752fa2471c580095725487f2d3ed"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dfdbd624efd49f7b680b81e8eee60ec3b920752fa2471c580095725487f2d3ed"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dfdbd624efd49f7b680b81e8eee60ec3b920752fa2471c580095725487f2d3ed"
    sha256 cellar: :any_skip_relocation, sonoma:        "24eb169bda3818716c1c34088bd9bde660b6cd05df2157298d899fb7a3d928f8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d57ccd71c9b7ca9ab6c7f2218fa94f84870a50ffd0ac7b42f7e0c3044a9fc8be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9a92990ed69b3a4b54e033acb8a9bbffeff458114d8ae237c904bde4cd11bdf2"
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