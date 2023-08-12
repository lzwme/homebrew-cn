class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https://pocketbase.io/"
  url "https://ghproxy.com/https://github.com/pocketbase/pocketbase/archive/refs/tags/v0.17.4.tar.gz"
  sha256 "b33dfc0894da9b2871a8961cff26d9a9ffc44959ed6b70c29f82238246ec2652"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1666f2b14047c038bfb88ef920bc14c5f588289db49bd86d0860ae5c530488dc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1666f2b14047c038bfb88ef920bc14c5f588289db49bd86d0860ae5c530488dc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1666f2b14047c038bfb88ef920bc14c5f588289db49bd86d0860ae5c530488dc"
    sha256 cellar: :any_skip_relocation, ventura:        "9ea36535e88c2ea398362724ebca4b24c6282f9d61f2fc7bb9b5babceb1e35dd"
    sha256 cellar: :any_skip_relocation, monterey:       "9ea36535e88c2ea398362724ebca4b24c6282f9d61f2fc7bb9b5babceb1e35dd"
    sha256 cellar: :any_skip_relocation, big_sur:        "9ea36535e88c2ea398362724ebca4b24c6282f9d61f2fc7bb9b5babceb1e35dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "94ef1c27e4de8d2d2f7fb43d7607abb9a7113a9960248cc3820082726b1d6065"
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