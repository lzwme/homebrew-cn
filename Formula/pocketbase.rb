class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https://pocketbase.io/"
  url "https://ghproxy.com/https://github.com/pocketbase/pocketbase/archive/refs/tags/v0.16.8.tar.gz"
  sha256 "028aa3b6ed665916f28db79becef68908e72d4417ecdb40508a0b8ad5f06047d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "da554b5d00c093ad8535d9dbdf53a9f18452051a225f82c54cc637d84d42898e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "da554b5d00c093ad8535d9dbdf53a9f18452051a225f82c54cc637d84d42898e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "da554b5d00c093ad8535d9dbdf53a9f18452051a225f82c54cc637d84d42898e"
    sha256 cellar: :any_skip_relocation, ventura:        "050e879a3b3b344153bc20af5015ab36c8990dd9ce2ffa82d61ebe5e8307c626"
    sha256 cellar: :any_skip_relocation, monterey:       "050e879a3b3b344153bc20af5015ab36c8990dd9ce2ffa82d61ebe5e8307c626"
    sha256 cellar: :any_skip_relocation, big_sur:        "050e879a3b3b344153bc20af5015ab36c8990dd9ce2ffa82d61ebe5e8307c626"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "12e1b80ee27239885f5b12f00208a35369d0a5ca5215788da6d914d769435373"
  end

  depends_on "go" => :build

  uses_from_macos "netcat" => :test

  def install
    ENV["CGO_ENABLED"] = "0"

    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/pocketbase/pocketbase.Version=#{version}"), "./examples/base"
  end

  test do
    assert_match "pocketbase version #{version}", shell_output("#{bin}/pocketbase --version")

    port = free_port
    _, _, pid = PTY.spawn("#{bin}/pocketbase serve --dir #{testpath}/pb_data --http 127.0.0.1:#{port}")
    sleep 5

    system "nc", "-z", "localhost", port
    Process.kill "SIGINT", pid

    assert_predicate testpath/"pb_data", :exist?, "pb_data directory should exist"
    assert_predicate testpath/"pb_data", :directory?, "pb_data should be a directory"

    assert_predicate testpath/"pb_data/data.db", :exist?, "pb_data/data.db should exist"
    assert_predicate testpath/"pb_data/data.db", :file?, "pb_data/data.db should be a file"

    assert_predicate testpath/"pb_data/logs.db", :exist?, "pb_data/logs.db should exist"
    assert_predicate testpath/"pb_data/logs.db", :file?, "pb_data/logs.db should be a file"
  end
end