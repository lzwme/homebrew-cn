class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https://pocketbase.io/"
  url "https://ghproxy.com/https://github.com/pocketbase/pocketbase/archive/refs/tags/v0.19.3.tar.gz"
  sha256 "d5c6eb45a2f943340e352313d86582baeb8c77c5083a2375d162f4ae399b40da"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "923ff147d579457eb04d96d43a6dbf13b8e85b379b201fb9b0333038ecfa603c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "923ff147d579457eb04d96d43a6dbf13b8e85b379b201fb9b0333038ecfa603c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "923ff147d579457eb04d96d43a6dbf13b8e85b379b201fb9b0333038ecfa603c"
    sha256 cellar: :any_skip_relocation, sonoma:         "7dd3c7c329d2eba5f7686ddc99f52d54541681e1d176891d29b9f66e044f14a1"
    sha256 cellar: :any_skip_relocation, ventura:        "7dd3c7c329d2eba5f7686ddc99f52d54541681e1d176891d29b9f66e044f14a1"
    sha256 cellar: :any_skip_relocation, monterey:       "7dd3c7c329d2eba5f7686ddc99f52d54541681e1d176891d29b9f66e044f14a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a4292cd57c2394a62aecba5326166bd1075fcef0ac54389fe57d241cac2e81f7"
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