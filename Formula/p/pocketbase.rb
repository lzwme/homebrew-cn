class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https://pocketbase.io/"
  url "https://ghfast.top/https://github.com/pocketbase/pocketbase/archive/refs/tags/v0.35.1.tar.gz"
  sha256 "8839523b4fe8df3c14297b1f5066002cc90ed94f8bb0411e96ee9ac17e1c61a3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "91f314517d66056bd799390e01d67c15e06775124157026f46bead404c69813d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "91f314517d66056bd799390e01d67c15e06775124157026f46bead404c69813d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "91f314517d66056bd799390e01d67c15e06775124157026f46bead404c69813d"
    sha256 cellar: :any_skip_relocation, sonoma:        "206906ba34dd06a81d07a45f8b0f0c313422c7c804d9be37a0b748213efb6805"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "96dde819611e3da82fc450ed4a5000d061d2b6c8da99b44267dc0ff49311205c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d1a59ebbc9b3e1adbf305abbad4af9360632011ba9518f5df4f3e8c01feed2a2"
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