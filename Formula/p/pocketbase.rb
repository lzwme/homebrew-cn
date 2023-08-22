class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https://pocketbase.io/"
  url "https://ghproxy.com/https://github.com/pocketbase/pocketbase/archive/refs/tags/v0.17.6.tar.gz"
  sha256 "130bb42b6ea0a39eafdc9217782c232c819f0196d875ab15b1f343ebbf3c73dd"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "697d8152f2b4542b0eea56ce2b20090e4dfa98e3e85a8d3900a7b7eceedcdd58"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "697d8152f2b4542b0eea56ce2b20090e4dfa98e3e85a8d3900a7b7eceedcdd58"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "697d8152f2b4542b0eea56ce2b20090e4dfa98e3e85a8d3900a7b7eceedcdd58"
    sha256 cellar: :any_skip_relocation, ventura:        "dd373805cc6872107de5eaa1389c2ada09e188c0d806e05640c8020500ca1543"
    sha256 cellar: :any_skip_relocation, monterey:       "dd373805cc6872107de5eaa1389c2ada09e188c0d806e05640c8020500ca1543"
    sha256 cellar: :any_skip_relocation, big_sur:        "dd373805cc6872107de5eaa1389c2ada09e188c0d806e05640c8020500ca1543"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ccd6dc4b3da6a42944b47727d405f9bda09ea60151dd88565417abcee6939c31"
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