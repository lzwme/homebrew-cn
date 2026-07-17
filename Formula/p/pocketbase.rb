class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https://pocketbase.io/"
  url "https://ghfast.top/https://github.com/pocketbase/pocketbase/archive/refs/tags/v0.39.7.tar.gz"
  sha256 "0cb526ebc0f148329a30dcd8ff7cae128b531690c0ad8945bd71db88bbf79e77"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1ed1d6b289cc5fb2845329744957185272efe7f30b3d69a2f64f0f011291d6ee"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1ed1d6b289cc5fb2845329744957185272efe7f30b3d69a2f64f0f011291d6ee"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1ed1d6b289cc5fb2845329744957185272efe7f30b3d69a2f64f0f011291d6ee"
    sha256 cellar: :any_skip_relocation, sonoma:        "ec7f559c6ed8226ee71e590b5e1447e29c76121911e06219b652344cdd297dbf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3c7874682697311b2d4fe03bc81233f6da298410aac12bcb351c0c4af8021177"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f4f633bf95f82c13814d5b964f92d971e834656721aa088afd9ac69fc9e53bbd"
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