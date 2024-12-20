class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https:pocketbase.io"
  url "https:github.compocketbasepocketbasearchiverefstagsv0.23.11.tar.gz"
  sha256 "564c3eff7a57e7f5913840f0ce85b09d01eba6e19ee6ea4c93cfd78fbdbf2653"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2b370f81e22b5190d3c230e504181b611640b4d7f1740db2562c0c8290f20fca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2b370f81e22b5190d3c230e504181b611640b4d7f1740db2562c0c8290f20fca"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2b370f81e22b5190d3c230e504181b611640b4d7f1740db2562c0c8290f20fca"
    sha256 cellar: :any_skip_relocation, sonoma:        "7895ddfc0444c672f7bc62b1ab530d2019469857b67d46e12238161e18f5200a"
    sha256 cellar: :any_skip_relocation, ventura:       "7895ddfc0444c672f7bc62b1ab530d2019469857b67d46e12238161e18f5200a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b3e2ce3dac37b57acc1e0cf4bf7904ec6c45a6a3b74006398e1e6649522dec25"
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