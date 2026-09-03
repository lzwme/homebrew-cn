class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https://pocketbase.io/"
  url "https://ghfast.top/https://github.com/pocketbase/pocketbase/archive/refs/tags/v0.40.2.tar.gz"
  sha256 "30e9277ad6a5783697b4e15756299c2c60c6b39feba79455c92d1d6979e8ff00"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2f740482e5499bd359e07d344f7543a78adbbbc2a0e718d524f8a031b3acae28"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2f740482e5499bd359e07d344f7543a78adbbbc2a0e718d524f8a031b3acae28"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2f740482e5499bd359e07d344f7543a78adbbbc2a0e718d524f8a031b3acae28"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e22be727888e1ac79907243a0724e8580549572e6f65f5f879faee76cfae88f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "762ce3a7d4bd6b6c77cb2feedc460069e9ae88047095e40aa3962108eeecec43"
  end

  depends_on "go" => :build

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