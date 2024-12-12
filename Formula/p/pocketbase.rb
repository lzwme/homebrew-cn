class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https:pocketbase.io"
  url "https:github.compocketbasepocketbasearchiverefstagsv0.23.6.tar.gz"
  sha256 "f6cf797624763f75f9a9ef50884452723daae87f0a5468154122d28118cab0ce"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "18b822a4385bc2898272fd3956d72c2896aa871cb564f9e8c9ffd55ce9d1d884"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "18b822a4385bc2898272fd3956d72c2896aa871cb564f9e8c9ffd55ce9d1d884"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "18b822a4385bc2898272fd3956d72c2896aa871cb564f9e8c9ffd55ce9d1d884"
    sha256 cellar: :any_skip_relocation, sonoma:        "ce9930b16a4970a1bdd0703df750cbb989dd61a41f2b1cf30754f1894839e8ea"
    sha256 cellar: :any_skip_relocation, ventura:       "ce9930b16a4970a1bdd0703df750cbb989dd61a41f2b1cf30754f1894839e8ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eb095df923a6b4893afbe248936e2eb7387d0d3178144c5296261b6faec9f2d2"
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