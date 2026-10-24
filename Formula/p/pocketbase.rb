class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https://pocketbase.io/"
  url "https://ghfast.top/https://github.com/pocketbase/pocketbase/archive/refs/tags/v0.40.6.tar.gz"
  sha256 "f5ed3d708d1598b9c8b2bbf07e0f1bfd9f4f6235a3157013a9a889d5081147e1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "35d06fb2ae04f98eb65ee49f8a57dfcb1b68393b366bb5ec14043d3896b6fac9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "35d06fb2ae04f98eb65ee49f8a57dfcb1b68393b366bb5ec14043d3896b6fac9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "35d06fb2ae04f98eb65ee49f8a57dfcb1b68393b366bb5ec14043d3896b6fac9"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "19ef7a7827899fb377ebce1cdf33f05fc7e23cc7f10b5a8a770fc19de8e8af21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "f6386945e5d96c9734ed70c9d241ae40c082d5a7c9f80672f319e1808d2f6e96"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = "0"

    system "go", "build", *std_go_args(ldflags: "-X github.com/pocketbase/pocketbase.Version=#{version}"), "./examples/base"
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