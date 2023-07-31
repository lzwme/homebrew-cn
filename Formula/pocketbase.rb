class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https://pocketbase.io/"
  url "https://ghproxy.com/https://github.com/pocketbase/pocketbase/archive/refs/tags/v0.17.0.tar.gz"
  sha256 "9d5c3492fcbaf4143a6d8e1580b162d8d7aaf2fd48e4e8aa27f28aba26075d62"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "45e82429092db039e0ab925b37a27e2966b333b173561264004a69d62bc389e2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "45e82429092db039e0ab925b37a27e2966b333b173561264004a69d62bc389e2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "45e82429092db039e0ab925b37a27e2966b333b173561264004a69d62bc389e2"
    sha256 cellar: :any_skip_relocation, ventura:        "c7f398f7d830d0c07b40bf647cd2479a427a675a7e954e4f6fcb3cb33e86408c"
    sha256 cellar: :any_skip_relocation, monterey:       "c7f398f7d830d0c07b40bf647cd2479a427a675a7e954e4f6fcb3cb33e86408c"
    sha256 cellar: :any_skip_relocation, big_sur:        "c7f398f7d830d0c07b40bf647cd2479a427a675a7e954e4f6fcb3cb33e86408c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "07dcd06ca2bbba641768fcde33abfe2e58815be1b951aba7c5d87fba57bbae23"
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