class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https://pocketbase.io/"
  url "https://ghproxy.com/https://github.com/pocketbase/pocketbase/archive/refs/tags/v0.18.3.tar.gz"
  sha256 "9c47b41b44538aaf6e4c61a2c396ab5e3254d0d7c540d76bda5ce865fac61772"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "39f04daad38bb6d47264a7f97b8ddc0e4412f9d4d2fe14edbc97cd2b52aa0447"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "39f04daad38bb6d47264a7f97b8ddc0e4412f9d4d2fe14edbc97cd2b52aa0447"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "39f04daad38bb6d47264a7f97b8ddc0e4412f9d4d2fe14edbc97cd2b52aa0447"
    sha256 cellar: :any_skip_relocation, ventura:        "4103e0530e97b108feee94944b35c3bdf0c382d55832b677e5fc4227e527b3ac"
    sha256 cellar: :any_skip_relocation, monterey:       "4103e0530e97b108feee94944b35c3bdf0c382d55832b677e5fc4227e527b3ac"
    sha256 cellar: :any_skip_relocation, big_sur:        "4103e0530e97b108feee94944b35c3bdf0c382d55832b677e5fc4227e527b3ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d6a522e1b3c5d0068e87ee51271deb5db936911d7d762ef9deff68f98541b253"
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