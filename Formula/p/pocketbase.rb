class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https:pocketbase.io"
  url "https:github.compocketbasepocketbasearchiverefstagsv0.24.3.tar.gz"
  sha256 "d92322f3940379f3ab361b20cbf3c61fd3b884a43c677e35c4a2d55bbb205b25"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "676049756ae5010e83a9ef700fdf13046689f9be8bcb36dcf965743d3f8b8bd7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "676049756ae5010e83a9ef700fdf13046689f9be8bcb36dcf965743d3f8b8bd7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "676049756ae5010e83a9ef700fdf13046689f9be8bcb36dcf965743d3f8b8bd7"
    sha256 cellar: :any_skip_relocation, sonoma:        "b24ff20e3b8d5c2fbaa8ae241578451c87a5b1e95eea48e731c47a23c94344d5"
    sha256 cellar: :any_skip_relocation, ventura:       "b24ff20e3b8d5c2fbaa8ae241578451c87a5b1e95eea48e731c47a23c94344d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "742b921fa147bce581265d139445f34a5c8a321659b8ccf760e30425d314e032"
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