class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https://pocketbase.io/"
  url "https://ghfast.top/https://github.com/pocketbase/pocketbase/archive/refs/tags/v0.31.0.tar.gz"
  sha256 "c028e3e08f9ef6ee4d5603972e0cfb8bc37a7b909b9b24f89c4eb94b8a968fca"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "473c410598b43621a42b426f531d8b80feb395f74570262886fca54eb6504723"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "473c410598b43621a42b426f531d8b80feb395f74570262886fca54eb6504723"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "473c410598b43621a42b426f531d8b80feb395f74570262886fca54eb6504723"
    sha256 cellar: :any_skip_relocation, sonoma:        "1f86fd9e2f4642ed5b6bc6276d6f92f6b851cc86c911c9982d849cc48095c201"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1e01258be99890e324f0effc2398f3cd968c471c899fab2933e5dcbe2612d3e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "67d6429950a8a8bfde5677ce069c8d6310f81ede7465e7d22efb91d8208b8df1"
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