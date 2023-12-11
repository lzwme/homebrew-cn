class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https://pocketbase.io/"
  url "https://ghproxy.com/https://github.com/pocketbase/pocketbase/archive/refs/tags/v0.20.0.tar.gz"
  sha256 "86d25ee5aac8a7d20ee344b7c89053ef6741dd4af443e54bf1a4ccbf61992050"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "43845a352edd6df6cdce931e3399d9729c1b361d4225b380b19174f60fecff88"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "43845a352edd6df6cdce931e3399d9729c1b361d4225b380b19174f60fecff88"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "43845a352edd6df6cdce931e3399d9729c1b361d4225b380b19174f60fecff88"
    sha256 cellar: :any_skip_relocation, sonoma:         "28327215d768b52b140914420828d6bb1a3dbf2338b911702c0e6652625131ab"
    sha256 cellar: :any_skip_relocation, ventura:        "28327215d768b52b140914420828d6bb1a3dbf2338b911702c0e6652625131ab"
    sha256 cellar: :any_skip_relocation, monterey:       "28327215d768b52b140914420828d6bb1a3dbf2338b911702c0e6652625131ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a05e54881995f69165c41bf86d1a1db383d9b5095a6c45e29543c63a8c9b896c"
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