class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https://pocketbase.io/"
  url "https://ghproxy.com/https://github.com/pocketbase/pocketbase/archive/refs/tags/v0.18.9.tar.gz"
  sha256 "3ee2a1a02190ea07b6467faf5a08b7f9fa395d4e0cd630a7f3968efa78deab8e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "164ed5ad9eb0c2f3c6711900424082debe214d74f84fe499c0fce9207ffdb7fa"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "164ed5ad9eb0c2f3c6711900424082debe214d74f84fe499c0fce9207ffdb7fa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "164ed5ad9eb0c2f3c6711900424082debe214d74f84fe499c0fce9207ffdb7fa"
    sha256 cellar: :any_skip_relocation, sonoma:         "2f1967c74da16adeb2945dbf51cb8da75cd7822cb3f182a59b2ee8263d02289c"
    sha256 cellar: :any_skip_relocation, ventura:        "2f1967c74da16adeb2945dbf51cb8da75cd7822cb3f182a59b2ee8263d02289c"
    sha256 cellar: :any_skip_relocation, monterey:       "2f1967c74da16adeb2945dbf51cb8da75cd7822cb3f182a59b2ee8263d02289c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3ab77c1978c4842285191e7c61a172f6d79837b35a9faaa7c67744b997ab89df"
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