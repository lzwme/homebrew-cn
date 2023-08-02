class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https://pocketbase.io/"
  url "https://ghproxy.com/https://github.com/pocketbase/pocketbase/archive/refs/tags/v0.17.1.tar.gz"
  sha256 "7150ef8bcdd0691b17ab56c323840ef38f0a2bba5fde1c6141833f3f6ff13e23"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fbb41719648675b8c1769384eefbaffdc567d51825ffaf702a164091a9852c77"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fbb41719648675b8c1769384eefbaffdc567d51825ffaf702a164091a9852c77"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fbb41719648675b8c1769384eefbaffdc567d51825ffaf702a164091a9852c77"
    sha256 cellar: :any_skip_relocation, ventura:        "28354e669d6377fbdcc3780a8198c60db18e430b1c294043bc872d1787d8030f"
    sha256 cellar: :any_skip_relocation, monterey:       "28354e669d6377fbdcc3780a8198c60db18e430b1c294043bc872d1787d8030f"
    sha256 cellar: :any_skip_relocation, big_sur:        "28354e669d6377fbdcc3780a8198c60db18e430b1c294043bc872d1787d8030f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8b94e972b2bd6e24d59e8143c72fd1d71aec2e8469970493b5fc3392bd70f12e"
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