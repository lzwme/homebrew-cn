class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https:pocketbase.io"
  url "https:github.compocketbasepocketbasearchiverefstagsv0.24.2.tar.gz"
  sha256 "3ed71abbe501d86731687edf2ab71533bae2a1d465be295bd3c6550d38ed43c3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1ceb7bae1fb7203732921cc7da3f6a610e850e7da17e7cb3b308291a06260b3e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1ceb7bae1fb7203732921cc7da3f6a610e850e7da17e7cb3b308291a06260b3e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1ceb7bae1fb7203732921cc7da3f6a610e850e7da17e7cb3b308291a06260b3e"
    sha256 cellar: :any_skip_relocation, sonoma:        "33da2524ed2037ec4ba927a92c316cf9e39a8cb168e5f255a0e52e41c37eac25"
    sha256 cellar: :any_skip_relocation, ventura:       "33da2524ed2037ec4ba927a92c316cf9e39a8cb168e5f255a0e52e41c37eac25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "89e6cb69232da9288db88b36793736faf6a94e4fc7a315a54596baa88c8b1fcd"
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

    assert_predicate testpath"pb_data", :exist?, "pb_data directory should exist"
    assert_predicate testpath"pb_data", :directory?, "pb_data should be a directory"

    assert_predicate testpath"pb_datadata.db", :exist?, "pb_datadata.db should exist"
    assert_predicate testpath"pb_datadata.db", :file?, "pb_datadata.db should be a file"

    assert_predicate testpath"pb_dataauxiliary.db", :exist?, "pb_dataauxiliary.db should exist"
    assert_predicate testpath"pb_dataauxiliary.db", :file?, "pb_dataauxiliary.db should be a file"
  ensure
    Process.kill "TERM", pid
  end
end