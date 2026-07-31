class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https://pocketbase.io/"
  url "https://ghfast.top/https://github.com/pocketbase/pocketbase/archive/refs/tags/v0.39.10.tar.gz"
  sha256 "ab5221468309beef9a1dedcbf7cfffc61e2b95e45f9844b7164fba8161cee015"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1a08ee60633a044d33f17573410654efe4155600facdea1bd2546cde8c63715d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1a08ee60633a044d33f17573410654efe4155600facdea1bd2546cde8c63715d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1a08ee60633a044d33f17573410654efe4155600facdea1bd2546cde8c63715d"
    sha256 cellar: :any_skip_relocation, sonoma:        "9461e2d9ff6d83c84e227401bab40ab2c2e5e58b4f5e803a413c8917527a2154"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b000e644a325f22357dfc7cb77ad65d5bdb43c29f18f5ebcbe04403d2ff2c68a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "27c430d12411102d5cd3f2c58f816b21b35729be826d13bdc0a3d8f79a61164b"
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