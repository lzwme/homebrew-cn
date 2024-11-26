class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https:pocketbase.io"
  url "https:github.compocketbasepocketbasearchiverefstagsv0.23.1.tar.gz"
  sha256 "ff724c9e983cece890695a2174db2fc2acef4b95d29cb5ebe6aaeb53be114dc8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6e15cf3114f88206b812910750f631a70f06b5cd540cc78a506a6bf93344fff1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6e15cf3114f88206b812910750f631a70f06b5cd540cc78a506a6bf93344fff1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6e15cf3114f88206b812910750f631a70f06b5cd540cc78a506a6bf93344fff1"
    sha256 cellar: :any_skip_relocation, sonoma:        "3ad8f3e982bcb8aa7446f07c6df747220bc5ba1e3975dbdeeca6897c19b16723"
    sha256 cellar: :any_skip_relocation, ventura:       "3ad8f3e982bcb8aa7446f07c6df747220bc5ba1e3975dbdeeca6897c19b16723"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b846b17cdbbbbe7a1acbe4b39df76410315f9a55059ca0cc511066b4485b8f8"
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