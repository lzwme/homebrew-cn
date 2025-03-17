class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https:pocketbase.io"
  url "https:github.compocketbasepocketbasearchiverefstagsv0.26.1.tar.gz"
  sha256 "cd299adf1491c15dff50c2f17f438b5127241ea63c30f5a4d98b4ec612bb6c41"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5323b6cf890622a740a3095e8b9f07190e8bb7589344b2bf196d200e991f1290"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5323b6cf890622a740a3095e8b9f07190e8bb7589344b2bf196d200e991f1290"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5323b6cf890622a740a3095e8b9f07190e8bb7589344b2bf196d200e991f1290"
    sha256 cellar: :any_skip_relocation, sonoma:        "ccdf5469be38ff3341c602632307746618810d94547e36a6470393abd85f4c0c"
    sha256 cellar: :any_skip_relocation, ventura:       "ccdf5469be38ff3341c602632307746618810d94547e36a6470393abd85f4c0c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e2803817bb77aefabb195aa06d4516983b9451ad58126e11993208c0f6a91a29"
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

    assert_path_exists testpath"pb_data", "pb_data directory should exist"
    assert_predicate testpath"pb_data", :directory?, "pb_data should be a directory"

    assert_path_exists testpath"pb_datadata.db", "pb_datadata.db should exist"
    assert_predicate testpath"pb_datadata.db", :file?, "pb_datadata.db should be a file"

    assert_path_exists testpath"pb_dataauxiliary.db", "pb_dataauxiliary.db should exist"
    assert_predicate testpath"pb_dataauxiliary.db", :file?, "pb_dataauxiliary.db should be a file"
  ensure
    Process.kill "TERM", pid
  end
end