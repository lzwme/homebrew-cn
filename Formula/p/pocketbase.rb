class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https://pocketbase.io/"
  url "https://ghfast.top/https://github.com/pocketbase/pocketbase/archive/refs/tags/v0.36.3.tar.gz"
  sha256 "6251bcc04f4fe3f3b8bb2175e17e55243333cddf6a0b809b4d11a12c79587ad3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c805c83574c9c71e114f885f5b91e7372c044d144f5dbad7b074a2208d927dbf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c805c83574c9c71e114f885f5b91e7372c044d144f5dbad7b074a2208d927dbf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c805c83574c9c71e114f885f5b91e7372c044d144f5dbad7b074a2208d927dbf"
    sha256 cellar: :any_skip_relocation, sonoma:        "3516d2ef6586b6d3eff7e7956e74baface2fc6afcec411e18f887df5ae0e694e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c1159f29a5d4f69c603b0f0d46f301117686cc3de5a673a2c8a6e1a33171d780"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9f90a4270f5a390fd48406c1730be743807217f239c3e5eca8be5e51f179026e"
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