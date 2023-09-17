class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https://pocketbase.io/"
  url "https://ghproxy.com/https://github.com/pocketbase/pocketbase/archive/refs/tags/v0.18.6.tar.gz"
  sha256 "386c68e85b415a3f9a7dcfd6c4341e2a842888702a893a4916834ccb5038e0f2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dff699f67f7fd619797eb1cba4e2f0d847606966209aec2645899c737d278708"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dff699f67f7fd619797eb1cba4e2f0d847606966209aec2645899c737d278708"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dff699f67f7fd619797eb1cba4e2f0d847606966209aec2645899c737d278708"
    sha256 cellar: :any_skip_relocation, ventura:        "1dc4d7dd5476bb4885bd6d6f4e3cff9119861721b083a3e7e4362b8e7b8fd77e"
    sha256 cellar: :any_skip_relocation, monterey:       "1dc4d7dd5476bb4885bd6d6f4e3cff9119861721b083a3e7e4362b8e7b8fd77e"
    sha256 cellar: :any_skip_relocation, big_sur:        "1dc4d7dd5476bb4885bd6d6f4e3cff9119861721b083a3e7e4362b8e7b8fd77e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "521ac996d81dd2de556b023d5f655444f1005c80e3a3e65c74ebb8b215b3b527"
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