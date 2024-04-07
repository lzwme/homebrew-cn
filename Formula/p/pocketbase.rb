class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https:pocketbase.io"
  url "https:github.compocketbasepocketbasearchiverefstagsv0.22.8.tar.gz"
  sha256 "2a8cf4d1f76f9349e9e0696ccf53acd3016887890f34d27842bfc5bf97dc4264"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8c3e2499d5b013294650f0d7604d922a60d1d2a100f4ffe88885a65950eb9059"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8c3e2499d5b013294650f0d7604d922a60d1d2a100f4ffe88885a65950eb9059"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8c3e2499d5b013294650f0d7604d922a60d1d2a100f4ffe88885a65950eb9059"
    sha256 cellar: :any_skip_relocation, sonoma:         "471d2f8b2466d440f2da67521364f810453c6ce5dfaf804858b29f8710478d80"
    sha256 cellar: :any_skip_relocation, ventura:        "471d2f8b2466d440f2da67521364f810453c6ce5dfaf804858b29f8710478d80"
    sha256 cellar: :any_skip_relocation, monterey:       "471d2f8b2466d440f2da67521364f810453c6ce5dfaf804858b29f8710478d80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9417e5c35f4cb1f111a32e8fb9e01a6a76150ae5f120f1c61e48f3a349944345"
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