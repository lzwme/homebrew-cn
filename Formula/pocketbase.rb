class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https://pocketbase.io/"
  url "https://ghproxy.com/https://github.com/pocketbase/pocketbase/archive/refs/tags/v0.17.3.tar.gz"
  sha256 "725694c76063883d5fb5febedc6078d7ebcb1f247d1ce9425b8988402e9e1adf"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c04602b4af60454c6b75dc1ce9c18e4b328b8b6ef1b6b56004cb21cb2a64a678"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c04602b4af60454c6b75dc1ce9c18e4b328b8b6ef1b6b56004cb21cb2a64a678"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c04602b4af60454c6b75dc1ce9c18e4b328b8b6ef1b6b56004cb21cb2a64a678"
    sha256 cellar: :any_skip_relocation, ventura:        "156f23f2e4558679d2cf7e28051d00c70330be6d08c5c45276103a8bc392961b"
    sha256 cellar: :any_skip_relocation, monterey:       "156f23f2e4558679d2cf7e28051d00c70330be6d08c5c45276103a8bc392961b"
    sha256 cellar: :any_skip_relocation, big_sur:        "156f23f2e4558679d2cf7e28051d00c70330be6d08c5c45276103a8bc392961b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f67354c371bb28bd6c101b8040c9c3c3cc311750af424828e553b5ab5c76a635"
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