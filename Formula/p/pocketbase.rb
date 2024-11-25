class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https:pocketbase.io"
  url "https:github.compocketbasepocketbasearchiverefstagsv0.23.0.tar.gz"
  sha256 "3d661a4a5666f481c91ee1ea39b8f748a391124055819f82b377410b87c96721"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c9468671a98043e45262f0691ee70d8b8b6e081a0779e3f7b9ab1fc934212191"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c9468671a98043e45262f0691ee70d8b8b6e081a0779e3f7b9ab1fc934212191"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c9468671a98043e45262f0691ee70d8b8b6e081a0779e3f7b9ab1fc934212191"
    sha256 cellar: :any_skip_relocation, sonoma:        "9ff5a26345cb8927f5173d100ad38c997f328a61945216f028e3168b16ae61ee"
    sha256 cellar: :any_skip_relocation, ventura:       "9ff5a26345cb8927f5173d100ad38c997f328a61945216f028e3168b16ae61ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "55ba7b305f471a754d6cb59327cdc760bb71075b261a2b6fc3ce1525c306443c"
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