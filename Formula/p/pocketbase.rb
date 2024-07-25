class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https:pocketbase.io"
  url "https:github.compocketbasepocketbasearchiverefstagsv0.22.18.tar.gz"
  sha256 "b4079400884f6f9ffcb0b05cb08079f6cf9ce27a77f37ce0a8861e07fe16a728"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "867acbf4f3f9b67d1686bef4a8140416af5e044271a1609f1e5d3b7d33f5c11f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "867acbf4f3f9b67d1686bef4a8140416af5e044271a1609f1e5d3b7d33f5c11f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "867acbf4f3f9b67d1686bef4a8140416af5e044271a1609f1e5d3b7d33f5c11f"
    sha256 cellar: :any_skip_relocation, sonoma:         "022436f445052ae37acce24b2051e992ff0c509f0b67ead77ebe5aad2a9f336b"
    sha256 cellar: :any_skip_relocation, ventura:        "022436f445052ae37acce24b2051e992ff0c509f0b67ead77ebe5aad2a9f336b"
    sha256 cellar: :any_skip_relocation, monterey:       "022436f445052ae37acce24b2051e992ff0c509f0b67ead77ebe5aad2a9f336b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "482d4b1356183c5cde583582dee823f5e19fe3a0d6642d986e56d515ea13319f"
  end

  depends_on "go" => :build

  uses_from_macos "netcat" => :test

  def install
    ENV["CGO_ENABLED"] = "0"

    system "go", "build", *std_go_args(ldflags: "-s -w -X github.compocketbasepocketbase.Version=#{version}"), ".examplesbase"
  end

  test do
    assert_match "pocketbase version #{version}", shell_output("#{bin}pocketbase --version")

    port = free_port
    _, _, pid = PTY.spawn("#{bin}pocketbase serve --dir #{testpath}pb_data --http 127.0.0.1:#{port}")
    sleep 5

    system "nc", "-z", "localhost", port
    Process.kill "SIGINT", pid

    assert_predicate testpath"pb_data", :exist?, "pb_data directory should exist"
    assert_predicate testpath"pb_data", :directory?, "pb_data should be a directory"

    assert_predicate testpath"pb_datadata.db", :exist?, "pb_datadata.db should exist"
    assert_predicate testpath"pb_datadata.db", :file?, "pb_datadata.db should be a file"

    assert_predicate testpath"pb_datalogs.db", :exist?, "pb_datalogs.db should exist"
    assert_predicate testpath"pb_datalogs.db", :file?, "pb_datalogs.db should be a file"
  end
end