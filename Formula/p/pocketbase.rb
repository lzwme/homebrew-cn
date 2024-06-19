class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https:pocketbase.io"
  url "https:github.compocketbasepocketbasearchiverefstagsv0.22.14.tar.gz"
  sha256 "382a11c5a495b78f9852f0063cc8538a7ca35d2a00eadb7e8d7cc8f1cfbb728f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5806f85b423c83bf561e6780420496544f03161062f421ddb2805848b75a3058"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5806f85b423c83bf561e6780420496544f03161062f421ddb2805848b75a3058"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5806f85b423c83bf561e6780420496544f03161062f421ddb2805848b75a3058"
    sha256 cellar: :any_skip_relocation, sonoma:         "5872f47bd60accc4b2aaafb340d68cff8939fa2064aa17f90ea6c08d3732fa78"
    sha256 cellar: :any_skip_relocation, ventura:        "5872f47bd60accc4b2aaafb340d68cff8939fa2064aa17f90ea6c08d3732fa78"
    sha256 cellar: :any_skip_relocation, monterey:       "5872f47bd60accc4b2aaafb340d68cff8939fa2064aa17f90ea6c08d3732fa78"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a8f599a2751aaf3e19ad32dc67a338e0f84e6d0aa2eefba0dce8ca6326894bd7"
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