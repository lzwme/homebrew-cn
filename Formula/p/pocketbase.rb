class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https://pocketbase.io/"
  url "https://ghfast.top/https://github.com/pocketbase/pocketbase/archive/refs/tags/v0.35.0.tar.gz"
  sha256 "0b5dd77f4759c31a4cda03a246b3a394e0e5f8b90bf7a79cf2ca1901ab57b3fe"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5e18289329ab836792737a534af19540d4cf7d46b0e414ad9954f876e5d6a75b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5e18289329ab836792737a534af19540d4cf7d46b0e414ad9954f876e5d6a75b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5e18289329ab836792737a534af19540d4cf7d46b0e414ad9954f876e5d6a75b"
    sha256 cellar: :any_skip_relocation, sonoma:        "e0b267a70872fcb3a262cfe328b57a5ac84b17fb0255f9a6d26dc2e75721a380"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c2c10780d01e58aa9a7fec85a6ec6f48d5c6c96841637905ad862c153a9e9fc8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cfd8a562796e6388e9abd123066d83d5efb0810da222d5919a7931714f02fa69"
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