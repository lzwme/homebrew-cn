class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https://pocketbase.io/"
  url "https://ghfast.top/https://github.com/pocketbase/pocketbase/archive/refs/tags/v0.36.6.tar.gz"
  sha256 "c1d1f605760e513d92fb1875b7540cf613802a203ee3cf8c3fbf52225ac216ed"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "316ffdc7610430d7bb583ae333787f34c98aab73e004415032bb607eb61a0bfd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "316ffdc7610430d7bb583ae333787f34c98aab73e004415032bb607eb61a0bfd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "316ffdc7610430d7bb583ae333787f34c98aab73e004415032bb607eb61a0bfd"
    sha256 cellar: :any_skip_relocation, sonoma:        "edd64c5d939a560d4dda085ee341cb9d99a8db54600a37ef6a4dc1395085fe5c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1c804ff0c38517fbe3a2eddb0323096662c9b45070eab28aa43f77b529b39dac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "043a6b61f4c3b452e276e6557ba79dd8079ec60d890293fffd42957a061a9457"
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