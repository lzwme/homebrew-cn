class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https://pocketbase.io/"
  url "https://ghfast.top/https://github.com/pocketbase/pocketbase/archive/refs/tags/v0.38.2.tar.gz"
  sha256 "a076d849128dbd4832856e9b615867b659616e40eb5c55bb6ffcc74e080600d2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "33247b16c952097effc06daa5233524531220f2d7e087b30923ba4b6df4d47c9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "33247b16c952097effc06daa5233524531220f2d7e087b30923ba4b6df4d47c9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "33247b16c952097effc06daa5233524531220f2d7e087b30923ba4b6df4d47c9"
    sha256 cellar: :any_skip_relocation, sonoma:        "82eff7ca312c700f110f3b94b2d39e335d5cf222b1eac414d1fbf38989245b94"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8c6c548f2c56d452832060b418169d3adc6745e6fca960eb523be7075b8317e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f74718850108de123c5b8023f7acc77ef16845a4000820e4eae7b2ac1c1a571d"
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