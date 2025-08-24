class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https://pocketbase.io/"
  url "https://ghfast.top/https://github.com/pocketbase/pocketbase/archive/refs/tags/v0.29.3.tar.gz"
  sha256 "29afd244329a61b84c592d2271e2e754a5dc506b6f09882d2727c7587fc38102"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6bd5b164ee26e0e882b3640ce839e46a864d00e0b99f43b366a90a4b9c5d3df7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6bd5b164ee26e0e882b3640ce839e46a864d00e0b99f43b366a90a4b9c5d3df7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6bd5b164ee26e0e882b3640ce839e46a864d00e0b99f43b366a90a4b9c5d3df7"
    sha256 cellar: :any_skip_relocation, sonoma:        "56b6a666e1a73e2d9504465a507589190fad214b620824be65922cf3d81b7312"
    sha256 cellar: :any_skip_relocation, ventura:       "56b6a666e1a73e2d9504465a507589190fad214b620824be65922cf3d81b7312"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f192817266b1a0d5454b11893ddb90b8f75fa9d161f0381966f9fdb93bb500b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "36ecca64081f6d393f322e8ae4c6747d3e979107d04aac69f9fa48770a143bde"
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