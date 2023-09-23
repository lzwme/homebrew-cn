class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https://pocketbase.io/"
  url "https://ghproxy.com/https://github.com/pocketbase/pocketbase/archive/refs/tags/v0.18.7.tar.gz"
  sha256 "62fb9f58eb86973bb30f406a68a12dbca734e59546ab46442b3679ee0158ba75"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "01e1fc273992133f4270147bffdbccfe0b8a2f7ad75845695314fa9f752aa116"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "01e1fc273992133f4270147bffdbccfe0b8a2f7ad75845695314fa9f752aa116"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "01e1fc273992133f4270147bffdbccfe0b8a2f7ad75845695314fa9f752aa116"
    sha256 cellar: :any_skip_relocation, ventura:        "b9315ed98e792e4d13a815c90a81fb3e91d9d5b433ec3a0f219f13da14a487f5"
    sha256 cellar: :any_skip_relocation, monterey:       "b9315ed98e792e4d13a815c90a81fb3e91d9d5b433ec3a0f219f13da14a487f5"
    sha256 cellar: :any_skip_relocation, big_sur:        "b9315ed98e792e4d13a815c90a81fb3e91d9d5b433ec3a0f219f13da14a487f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b9ee1b31f3ab464cab04f1fb3f19b971922ffa295d66ef96feab9f7d6773ec50"
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