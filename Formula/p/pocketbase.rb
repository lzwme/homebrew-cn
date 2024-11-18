class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https:pocketbase.io"
  url "https:github.compocketbasepocketbasearchiverefstagsv0.22.26.tar.gz"
  sha256 "a0dd86bd905ac7b8dfffcd1149429b235f6f251668b28df09b7ee94edb9c0744"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fa82f23131aa891201e87dae33b164ba6555444980e2851247f3793ba3b0032c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fa82f23131aa891201e87dae33b164ba6555444980e2851247f3793ba3b0032c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fa82f23131aa891201e87dae33b164ba6555444980e2851247f3793ba3b0032c"
    sha256 cellar: :any_skip_relocation, sonoma:        "a44fc77cd2b4d4fd73d1cf35c067ab2033225c7e439f7cceb4b7cdebc54033e6"
    sha256 cellar: :any_skip_relocation, ventura:       "a44fc77cd2b4d4fd73d1cf35c067ab2033225c7e439f7cceb4b7cdebc54033e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "58e43d3ee9b39968950528f2b9e4f92f4b524a443f854d58be7ea5427631afe4"
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