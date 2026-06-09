class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https://pocketbase.io/"
  url "https://ghfast.top/https://github.com/pocketbase/pocketbase/archive/refs/tags/v0.39.3.tar.gz"
  sha256 "caa338cee853df71493cdb9c7d40e82c3fc901d521ae65db70717afc46738314"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "92e8d279f09ad176427f0e61ef43c4872b7ed63cbcac5bd587a0e184591483e5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "92e8d279f09ad176427f0e61ef43c4872b7ed63cbcac5bd587a0e184591483e5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "92e8d279f09ad176427f0e61ef43c4872b7ed63cbcac5bd587a0e184591483e5"
    sha256 cellar: :any_skip_relocation, sonoma:        "d83b0f020a1fabd5346393e901c7caded579920ea26f278adc3477c4fe25e176"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "33c61f0975754e84e9b14a0cc3a29e7b4632b2ea81e0f64a794dcadcbcb09a33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "37cc808d35fdb0782381a7fe4e00931446fbe3abfd5170bd818715934e45983a"
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