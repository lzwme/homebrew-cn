class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https://pocketbase.io/"
  url "https://ghproxy.com/https://github.com/pocketbase/pocketbase/archive/refs/tags/v0.16.10.tar.gz"
  sha256 "3b5b4789119a6e1cbc12a3044a4b1a752172604bf4737de1fb33bba1c0726f1e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "55ed9f7fd48a847032ecf07d8ee22a1e8df166ef7490da89a20110f4aa81a3e1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "55ed9f7fd48a847032ecf07d8ee22a1e8df166ef7490da89a20110f4aa81a3e1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "55ed9f7fd48a847032ecf07d8ee22a1e8df166ef7490da89a20110f4aa81a3e1"
    sha256 cellar: :any_skip_relocation, ventura:        "078a70f1a6661bf9039ceab538c5bb741934761e5630a492fccd6e783ab8d989"
    sha256 cellar: :any_skip_relocation, monterey:       "078a70f1a6661bf9039ceab538c5bb741934761e5630a492fccd6e783ab8d989"
    sha256 cellar: :any_skip_relocation, big_sur:        "078a70f1a6661bf9039ceab538c5bb741934761e5630a492fccd6e783ab8d989"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9630a8f755b4d7d95e99417c25d4f1c11fee4753bde95de6c0bb5e6dfcb99487"
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