class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https:pocketbase.io"
  url "https:github.compocketbasepocketbasearchiverefstagsv0.20.1.tar.gz"
  sha256 "f12274b5c49777c384a6e16868831e6b9077d44db3e51af6bef4488c4fdeedcf"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bde7e398a6ebc64638eea0ac1a4cceebb90353ea87905955a80788c296055432"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bde7e398a6ebc64638eea0ac1a4cceebb90353ea87905955a80788c296055432"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bde7e398a6ebc64638eea0ac1a4cceebb90353ea87905955a80788c296055432"
    sha256 cellar: :any_skip_relocation, sonoma:         "7cd576bb2fad580897e78e7689865332c237e56c7b9fcd5054fd9e6a95ee1718"
    sha256 cellar: :any_skip_relocation, ventura:        "7cd576bb2fad580897e78e7689865332c237e56c7b9fcd5054fd9e6a95ee1718"
    sha256 cellar: :any_skip_relocation, monterey:       "7cd576bb2fad580897e78e7689865332c237e56c7b9fcd5054fd9e6a95ee1718"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "464c51f4376aec93468d795877b3181e20f87874f30c7b3b80945598dcbebfe2"
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