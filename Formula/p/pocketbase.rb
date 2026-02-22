class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https://pocketbase.io/"
  url "https://ghfast.top/https://github.com/pocketbase/pocketbase/archive/refs/tags/v0.36.5.tar.gz"
  sha256 "94c44ac0508af487c626c714b8367baa3141ddf5fb260ccf65117dd777ac066e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "26111bcbf1dda0f0e4cc4f343d92bc1899d045a9e406580a27b47fd3654aba62"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "26111bcbf1dda0f0e4cc4f343d92bc1899d045a9e406580a27b47fd3654aba62"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "26111bcbf1dda0f0e4cc4f343d92bc1899d045a9e406580a27b47fd3654aba62"
    sha256 cellar: :any_skip_relocation, sonoma:        "a65fe1f7ed1be884f9abdd1dcfc0fb7659ed36828eecfb128d79e288958543b5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "644fff79723d7e8465af18d1164ebfd235e48e8049f813ed47e96cc41e050cb4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8a9114f07ff662c73e3d070f284d12710531e80ac91a832127a271549c5e9a6d"
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